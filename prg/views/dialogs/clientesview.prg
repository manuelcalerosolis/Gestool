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

RETURN ( self )

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
      FONT        getBoldFont() ;
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

   /*
   Botones generales-----------------------------------------------------------
   */

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

   ::oController:oDireccionesController:oDialogView:ExternalRedefine( ::oFolder:aDialogs[1] )

   REDEFINE GET   ::oController:oModel:hBuffer[ "web" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "establecimiento" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:oArticulosTarifasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "tarifa_codigo" ] ) )
   ::oController:oArticulosTarifasController:oGetSelector:Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[1] } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD redefineComercial() CLASS ClientesView

   ::oController:oCuentasRemesasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_remesa_codigo" ] ) )
   ::oController:oCuentasRemesasController:oGetSelector:Build( { "idGet" => 110, "idText" => 111, "idLink" => 112, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:oRutasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "ruta_codigo" ] ) )
   ::oController:oRutasController:oGetSelector:Build( { "idGet" => 120, "idText" => 121, "idLink" => 122, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:oAgentesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "agente_codigo" ] ) )
   ::oController:oAgentesController:oGetSelector:Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:oClientesGruposController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente_grupo_codigo" ] ) )
   ::oController:oClientesGruposController:oGetSelector:Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[2] } )

   ::oController:oFormasPagoController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "forma_pago_codigo" ] ) )
   ::oController:oFormasPagoController:oGetSelector:Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[2] } )

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


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD redefineContabilidad() CLASS ClientesView

   REDEFINE SAY ::oInfoSubCuenta ;
      PROMPT   "Subcuenta..." ;
      FONT     getBoldFont() ; 
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
      FONT     getBoldFont() ; 
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
      FONT     getBoldFont() ; 
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

   RETURN ( self )
//---------------------------------------------------------------------------//
METHOD startDialog()


   ::addLinksToExplorerBar()
   
   ::oController:oAgentesController:oGetSelector:Start()

   ::oController:oArticulosTarifasController:oGetSelector:Start()

   ::oController:oFormasPagoController:oGetSelector:Start()

   ::oController:oCuentasRemesasController:oGetSelector:Start()

   ::oController:oRutasController:oGetSelector:Start()

   ::oController:oClientesGruposController:oGetSelector:Start()

   ::oController:oDireccionesController:externalStartDialog()

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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ClientesView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Tarifas...",             {|| ::oController:oClientesTarifasController:activateDialogView() }, ::oController:oClientesTarifasController:getImage( "16" ) )
      oPanel:AddLink( "Direcciones...",         {|| ::oController:oDireccionesController:activateDialogView() }, ::oController:oDireccionesController:getImage( "16" ) )
      oPanel:AddLink( "Contactos...",           {|| ::oController:oContactosController:activateDialogView() }, ::oController:oContactosController:getImage( "16" ) )
      oPanel:AddLink( "Cuentas bancarias...",   {|| ::oController:oCuentasBancariasController:activateDialogView() }, ::oController:oCuentasBancariasController:getImage( "16" ) )
      oPanel:AddLink( "Incidencias...",         {|| ::oController:oIncidenciasController:activateDialogView() }, ::oController:oIncidenciasController:getImage( "16" ) )
      oPanel:AddLink( "Documentos...",          {|| ::oController:oDocumentosController:activateDialogView() }, ::oController:oDocumentosController:getImage( "16" ) )
      oPanel:AddLink( "Entidades facturae...",  {|| ::oController:oClientesEntidadesController:activateDialogView() }, ::oController:oClientesEntidadesController:getImage( "16" ) )
      oPanel:AddLink( "Descuentos...",          {|| ::oController:oDescuentosController:activateDialogView( ::oController:getUuid() ) }, ::oController:oDescuentosController:getImage( "16" ) )
   end if

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Campos extra...",        {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }, ::oController:oCamposExtraValoresController:getImage( "16" ) )
   end if

RETURN ( self )

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

Return ( self )

//---------------------------------------------------------------------------//

METHOD loadFechaLlamada() CLASS ClientesView

   hSet( ::oController:oModel:hBuffer, "fecha_ultima_llamada", date() )

   ::oGetFechaUltimaLlamada:Refresh()

Return ( self )

//---------------------------------------------------------------------------//

METHOD changeAutorizacioncredito()

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

Return ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//