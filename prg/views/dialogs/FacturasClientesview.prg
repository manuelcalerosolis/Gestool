#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS FacturasClientesView FROM SQLBaseView
  
   DATA oExplorerBar

   DATA oGetNumero
   
   METHOD Activate()

   METHOD Activating()

   METHOD startDialog()

   METHOD addLinksToExplorerBar()

   METHOD isClientEmpty()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS FacturasClientesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isClientEmpty() CLASS FacturasClientesView

RETURN ( empty( ::oController:getModelBuffer( "cliente_codigo" ) ) )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FacturasClientesView

   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRANSACION_COMERCIAL" ;
      TITLE       ::LblTitle() + "factura cliente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Clientes" ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "General",;
                  "Comercial";
      DIALOGS     "TRANSACION_GENERAL" ,;
                  "CLIENTE_COMERCIAL" 

   ::redefineExplorerBar()

   // Cliente------------------------------------------------------------------

   ::oController:oClientesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente_codigo" ] ) )
   ::oController:oClientesController:oGetSelector:Build( { "idGet" => 170, "idLink" => 171, "idText" => 180, "idNif" => 181, "idDireccion" => 183, "idCodigoPostal" => 184, "idPoblacion" => 185, "idProvincia" => 186, "idTelefono" => 187, "oDialog" => ::oFolder:aDialogs[1] } )

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
   ::oController:oAlmacenesController:oGetSelector:Activate( 230, 231, ::oFolder:aDialogs[1] )

   // Tarifas------------------------------------------------------------------

   ::oController:oArticulosTarifasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "tarifa_codigo" ] ) )
   ::oController:oArticulosTarifasController:oGetSelector:Activate( 270, 271, ::oFolder:aDialogs[1] )

   // Lineas ------------------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          500 ;
      OF          ::oFolder:aDialogs[1] ;
      WHEN        ( !::isClientEmpty() ) ;

   oBtnAppend:bAction   := {|| ::oController:oLineasController:Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          501 ;
      OF          ::oFolder:aDialogs[1] ;
      WHEN        ( !::isClientEmpty() ) ;

   oBtnEdit:bAction     := {|| ::oController:oLineasController:Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          502 ;
      OF          ::oFolder:aDialogs[1] ;
      WHEN        ( !::isClientEmpty() ) ;

   oBtnDelete:bAction   := {|| ::oController:oLineasController:Delete() }

   ::oController:oLineasController:Activate( 600, ::oFolder:aDialogs[1] )   

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
      ::oDialog:AddFastKey( VK_F2, {|| if( !::isClientEmpty(), ::oController:oLineasController:Append(), ) } )
      ::oDialog:AddFastKey( VK_F3, {|| if( !::isClientEmpty(), ::oController:oLineasController:Edit(), ) } )
      ::oDialog:AddFastKey( VK_F4, {|| if( !::isClientEmpty(), ::oController:oLineasController:Delete(), ) } )
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

   ::oController:oLineasController:oBrowseView:Refresh()

   ::oController:oArticulosTarifasController:oGetSelector:start()

   ::oController:oClientesController:oGetSelector:setFocus()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS FacturasClientesView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if

   oPanel:AddLink( "Incidencias...",            {|| MsgInfo( "Incidencias" ) }, "gc_money_interest_16" )

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Campos extra...",        {|| MsgInfo( "Incidencias" ) }, "gc_money_interest_16" )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//