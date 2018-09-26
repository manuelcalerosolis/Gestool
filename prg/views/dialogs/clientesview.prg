#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientesView FROM SQLBaseView
  
   DATA oExplorerBar

   DATA oGetDni
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais

   DATA oGetFechaBloqueo
   DATA oGetCausaBloqueo

   DATA oGetAgentes

   DATA oGetFechaUltimaLlamada

   DATA oGetFechaPeticion
   DATA oGetFechaConcesion

   DATA oBloqueoRiesgo
   DATA oRiesgo
   
   DATA oRiesgoAlcanzado
   DATA nRiesgoAlcanzado               INIT 0

   DATA oInfoSubCuenta
   DATA oInfoSubCuentaDescuento

   DATA oGetSubcuenta
   DATA oGetCuentaVenta
   DATA oGetSubcuentaDescuento

   DATA oSaldoSubcuenta
   DATA nSaldoSubcuenta

   DATA oSaldoSubcuentaDescuento
   DATA nSaldoSubcuentaDescuento

   METHOD Activate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

   METHOD startDialog()

   METHOD redefineGeneral()

   METHOD redefineComercial()

   METHOD redefineContabilidad()

   METHOD addLinksToExplorerBar()

   METHOD changeBloqueo()

   METHOD loadFechaLlamada()

   METHOD changeAutorizacioncredito()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ClientesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ClientesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + "cliente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Clientes" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "General",;
                  "Comercial",;
                  "Contabilidad";
      DIALOGS     "CLIENTE_GENERAL" ,;
                  "CLIENTE_COMERCIAL",;
                  "CLIENTE_CONTABILIDAD";

   ::redefineGeneral()   

   ::redefineComercial()

   ::redefineContabilidad()

   ::redefineExplorerBar()

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
   end if

   ::oDialog:bStart := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD redefineGeneral() CLASS ClientesView

   local oSay

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( "@! NNNNNNNNNNNN" ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetDni VAR ::oController:oModel:hBuffer[ "dni" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( CheckCif( ::oGetDni ) );
      OF          ::oFolder:aDialogs[1]

   ::oController:getDireccionesController():getDialogView():ExternalRedefine( ::oFolder:aDialogs[1] )

   REDEFINE GET   ::oController:oModel:hBuffer[ "web" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "establecimiento" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:getArticulosTarifasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "tarifa_codigo" ] ) )
   ::oController:getArticulosTarifasController():getSelector():Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[1] } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD redefineComercial() CLASS ClientesView

   ::oController:getCuentasRemesaController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_remesa_codigo" ] ) )
   ::oController:getCuentasRemesaController():getSelector():Build( { "idGet" => 110, "idText" => 111, "idLink" => 112, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:getRutasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "ruta_codigo" ] ) )
   ::oController:getRutasController():getSelector():Build( { "idGet" => 120, "idText" => 121, "idLink" => 122, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:getAgentesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "agente_codigo" ] ) )
   ::oController:getAgentesController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:getClientesGruposController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente_grupo_codigo" ] ) )
   ::oController:getClientesGruposController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:getFormasPagosController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "forma_pago_codigo" ] ) )
   ::oController:getFormasPagosController():getSelector():Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[2] } )

   REDEFINE GET ::oController:oModel:hBuffer[ "primer_dia_pago" ] ;
      ID       160;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oController:oModel:hBuffer[ "segundo_dia_pago" ] ;
      ID       170;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oController:oModel:hBuffer[ "tercer_dia_pago" ] ;
      ID       310;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::oController:oModel:hBuffer[ "mes_vacaciones" ];
      ITEMS    AMESES ;
      ID       180 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::oController:oModel:hBuffer[ "regimen_iva" ];
      ITEMS    AREGIMENIVA ;
      ID       190 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "recargo_equivalencia" ] ;
      ID       200 ;
      IDSAY    202 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oController:oModel:hBuffer[ "porcentaje_irpf" ] ;
      ID       210;
      SPINNER ;
      PICTURE  "@E 999.99" ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "bloqueado" ] ;
      ID       220 ;
      IDSAY    222 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      ON CHANGE( ::changeBloqueo() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaBloqueo ; 
      VAR      ::oController:oModel:hBuffer[ "fecha_bloqueo" ] ;
      ID       230 ;
      IDSAY    232 ;
      SPINNER ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetCausaBloqueo ;
      VAR      ::oController:oModel:hBuffer[ "causa_bloqueo" ] ;
      ID       240 ;
      IDSAY    242 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "autorizado_venta_credito" ] ;
      ID       250 ;
      IDSAY    252 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      ON CHANGE( ::changeAutorizacioncredito() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaPeticion ; 
      VAR      ::oController:oModel:hBuffer[ "fecha_peticion_riesgo" ] ;
      ID       260 ;
      IDSAY    262 ;
      SPINNER ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaConcesion ; 
      VAR      ::oController:oModel:hBuffer[ "fecha_concesion_riesgo" ] ;
      ID       270 ;
      IDSAY    272 ;
      SPINNER ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::oBloqueoRiesgo ;
      VAR      ::oController:oModel:hBuffer[ "bloquear_riesgo_alcanzado" ] ;
      ID       280 ;
      IDSAY    282 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oRiesgo ; 
      VAR      ::oController:oModel:hBuffer[ "riesgo" ] ;
      ID       290;
      IDSAY    292 ;
      SPINNER ;
      PICTURE  "@E 9999999999999999.99" ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oRiesgoAlcanzado ; 
      VAR      ::nRiesgoAlcanzado ;
      ID       300;
      IDSAY    302 ;
      PICTURE  "@E 9999999999999999.99" ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "excluir_fidelizacion" ] ;
      ID          320 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[2]

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "no_editar_datos" ] ;
      ID          330 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaUltimaLlamada ;
      VAR         ::oController:oModel:hBuffer[ "fecha_ultima_llamada" ] ;
      ID          340 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[2]

   TBtnBmp():ReDefine( 350, "gc_recycle_16",,,,,{|| ::loadFechaLlamada() }, ::oFolder:aDialogs[2], .f., {|| ::oController:isNotZoomMode() }, .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD redefineContabilidad() CLASS ClientesView

   REDEFINE SAY ::oInfoSubCuenta ;
      PROMPT   "Subcuenta..." ;
      FONT     oFontBold() ; 
      COLOR    rgb( 10, 152, 234 ) ;
      ID       320 ;
      OF       ::oFolder:aDialogs[3]

   ::oInfoSubCuenta:lWantClick  := .t.
   ::oInfoSubCuenta:OnClick     := {|| if( ::oController:isNotZoomMode(),  msgalert( "Informe subcuenta del cliente" ), ) }

   REDEFINE GET ::oGetSubcuenta ; 
      VAR      ::oController:oModel:hBuffer[ "subcuenta" ] ;
      ID       330 ;
      IDTEXT   331 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      ON HELP  ( MsgInfo( "Conectar con Contaplus" ) ) ;
      BITMAP   "LUPA" ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE GET ::oSaldoSubcuenta ; 
      VAR      ::nSaldoSubcuenta ;
      ID       340;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE SAY ::oInfoSubCuenta ;
      PROMPT   "Cuenta venta" ;
      FONT     oFontBold() ; 
      COLOR    rgb( 10, 152, 234 ) ;
      ID       352 ;
      OF       ::oFolder:aDialogs[3]

   ::oInfoSubCuenta:lWantClick  := .t.
   ::oInfoSubCuenta:OnClick     := {|| if( ::oController:isNotZoomMode(),  msgalert( "Informe cuenta venta del cliente" ), ) }

   REDEFINE GET ::oGetCuentaVenta ; 
      VAR      ::oController:oModel:hBuffer[ "cuenta_venta" ] ;
      ID       350 ;
      IDTEXT   351 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      ON HELP  ( MsgInfo( "Conectar con Contaplus" ) ) ;
      BITMAP   "LUPA" ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE SAY ::oInfoSubCuentaDescuento ;
      PROMPT   "Descuento..." ;
      FONT     oFontBold() ; 
      COLOR    rgb( 10, 152, 234 ) ;
      ID       360 ;
      OF       ::oFolder:aDialogs[3]

   ::oInfoSubCuentaDescuento:lWantClick  := .t.
   ::oInfoSubCuentaDescuento:OnClick     := {|| if( ::oController:isNotZoomMode(), msgalert( "Informe subcuenta dedescuento" ), ) }

   REDEFINE GET ::oGetSubcuentaDescuento ; 
      VAR      ::oController:oModel:hBuffer[ "cuenta_venta" ] ;
      ID       370 ;
      IDTEXT   371 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      ON HELP  ( MsgInfo( "Conectar con Contaplus" ) ) ;
      BITMAP   "LUPA" ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE GET ::oSaldoSubcuentaDescuento ; 
      VAR      ::nSaldoSubcuentaDescuento ;
      ID       380;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[3]

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS ClientesView

   ::addLinksToExplorerBar()
   
   ::oController:getAgentesController():getSelector():Start()

   ::oController:getArticulosTarifasController():getSelector():Start()

   ::oController:getFormasPagosController():getSelector():Start()

   ::oController:getCuentasRemesaController():getSelector():Start()

   ::oController:getRutasController():getSelector():Start()

   ::oController:getClientesGruposController():getSelector():Start()

   ::oController:getDireccionesController():externalStartDialog()

   if !::oController:oModel:hBuffer[ "bloqueado" ]
      ::oGetFechaBloqueo:Hide()
      ::oGetCausaBloqueo:Hide()
   end if

   if !::oController:oModel:hBuffer[ "autorizado_venta_credito" ]
      ::oGetFechaPeticion:Hide()
      ::oGetFechaConcesion:Hide()
      ::oBloqueoRiesgo:Hide()
      ::oRiesgo:Hide()
      ::oRiesgoAlcanzado:Hide()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ClientesView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Tarifas...",             {|| ::oController:getClientesTarifasController():activateDialogView() }, ::oController:getClientesTarifasController():getImage( "16" ) )
      oPanel:AddLink( "Direcciones...",         {|| ::oController:getDireccionesController():activateDialogView() }, ::oController:getDireccionesController():getImage( "16" ) )
      oPanel:AddLink( "Contactos...",           {|| ::oController:getContactosController():activateDialogView() }, ::oController:getContactosController():getImage( "16" ) )
      oPanel:AddLink( "Cuentas bancarias...",   {|| ::oController:getCuentasBancariasController():activateDialogView() }, ::oController:getCuentasBancariasController():getImage( "16" ) )
      oPanel:AddLink( "Incidencias...",         {|| ::oController:getIncidenciasController():activateDialogView() }, ::oController:getIncidenciasController():getImage( "16" ) )
      oPanel:AddLink( "Documentos...",          {|| ::oController:getDocumentosController():activateDialogView() }, ::oController:getDocumentosController():getImage( "16" ) )
      oPanel:AddLink( "Entidades facturae...",  {|| ::oController:getClientesEntidadesController():activateDialogView() }, ::oController:getClientesEntidadesController():getImage( "16" ) )
      oPanel:AddLink( "Descuentos...",          {|| ::oController:getDescuentosController():activateDialogView( ::oController:getUuid() ) }, ::oController:getDescuentosController():getImage( "16" ) )
   end if

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Campos extra...",        {|| ::getController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }, ::oController:getCamposExtraValoresController():getImage( "16" ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeBloqueo() CLASS ClientesView

   if ::oController:oModel:hBuffer[ "bloqueado" ]
      
      hSet( ::oController:oModel:hBuffer, "fecha_bloqueo", date() )
      ::oGetFechaBloqueo:Show()
      
      ::oGetCausaBloqueo:Show()

   else
      
      hSet( ::oController:oModel:hBuffer, "fecha_bloqueo", cTod( "" ) )
      ::oGetFechaBloqueo:Hide()

      hSet( ::oController:oModel:hBuffer, "causa_bloqueo", Space( 100 ) )
      ::oGetCausaBloqueo:Hide()

   end if

   ::oGetFechaBloqueo:Refresh()
   
   ::oGetCausaBloqueo:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD loadFechaLlamada() CLASS ClientesView

   hSet( ::oController:oModel:hBuffer, "fecha_ultima_llamada", date() )

   ::oGetFechaUltimaLlamada:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD changeAutorizacioncredito() CLASS ClientesView

   if ::oController:oModel:hBuffer[ "autorizado_venta_credito" ]
      
      ::oGetFechaPeticion:Show()
      ::oGetFechaConcesion:Show()
      ::oBloqueoRiesgo:Show()
      ::oRiesgo:Show()
      ::oRiesgoAlcanzado:Show()

   else
      
      hSet( ::oController:oModel:hBuffer, "fecha_peticion_riesgo", cTod( "" ) )
      hSet( ::oController:oModel:hBuffer, "fecha_concesion_riesgo", cTod( "" ) )
      hSet( ::oController:oModel:hBuffer, "riesgo", 0 )

      ::oGetFechaPeticion:Hide()
      ::oGetFechaConcesion:Hide()
      ::oBloqueoRiesgo:Hide()
      ::oRiesgo:Hide()
      ::oRiesgoAlcanzado:Hide()

   end if

   ::oGetFechaPeticion:Refresh()
   ::oGetFechaConcesion:Refresh()
   ::oBloqueoRiesgo:Refresh()
   ::oRiesgo:Refresh()
   ::oRiesgoAlcanzado:Refresh() 

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//