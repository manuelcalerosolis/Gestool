#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS TercerosView FROM SQLBaseView
  
   DATA oExplorerBar

   DATA oGetCodigo
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

   METHOD getDireccionesController()   INLINE ( ::getController():oDireccionesController )

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

METHOD Activating() CLASS TercerosView

   if ::getController():isAppendOrDuplicateMode()
      ::getController():oModel:hBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TercerosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + ::getController():cTitle

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::getController():getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      ::getController():cMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "General" ,;
                  "Comercial" ,;
                  "Contabilidad" ;
      DIALOGS     "CLIENTE_GENERAL" ,;
                  "CLIENTE_COMERCIAL" ,;
                  "CLIENTE_CONTABILIDAD"

   ::redefineGeneral()   

   ::redefineComercial()

   ::redefineContabilidad()

   ::redefineExplorerBar()

   // Botones generales--------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::getController():isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart        := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD redefineGeneral() CLASS TercerosView

   REDEFINE GET   ::oGetCodigo ;
      VAR         ::getController():oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( "@! NNNNNNNNNNNN" ) ;
      WHEN        ( ::getController():isAppendOrDuplicateMode() ) ;
      VALID       ( ::getController():validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::getController():oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( ::getController():validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetDni VAR ::getController():oModel:hBuffer[ "dni" ] ;
      ID          120 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( CheckCif( ::oGetDni ) );
      OF          ::oFolder:aDialogs[1]

   ::getController():getDireccionesController():getDialogView():ExternalRedefine( ::oFolder:aDialogs[1] )

   REDEFINE GET   ::getController():oModel:hBuffer[ "web" ] ;
      ID          130 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::getController():oModel:hBuffer[ "establecimiento" ] ;
      ID          140 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::getController():getArticulosTarifasController():getSelector():Bind( bSETGET( ::getController():oModel:hBuffer[ "tarifa_codigo" ] ) )
   ::getController():getArticulosTarifasController():getSelector():Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[1] } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD redefineComercial() CLASS TercerosView

   ::getController():getCuentasRemesaController():getSelector():Bind( bSETGET( ::getController():oModel:hBuffer[ "cuenta_remesa_codigo" ] ) )
   ::getController():getCuentasRemesaController():getSelector():Build( { "idGet" => 110, "idText" => 111, "idLink" => 112, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getRutasController():getSelector():Bind( bSETGET( ::getController():oModel:hBuffer[ "ruta_codigo" ] ) )
   ::getController():getRutasController():getSelector():Build( { "idGet" => 120, "idText" => 121, "idLink" => 122, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getAgentesController():getSelector():Bind( bSETGET( ::getController():oModel:hBuffer[ "agente_codigo" ] ) )
   ::getController():getAgentesController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getClientesGruposController():getSelector():Bind( bSETGET( ::getController():oModel:hBuffer[ "cliente_grupo_codigo" ] ) )
   ::getController():getClientesGruposController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getFormasPagosController():getSelector():Bind( bSETGET( ::getController():oModel:hBuffer[ "forma_pago_codigo" ] ) )
   ::getController():getFormasPagosController():getSelector():Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[2] } )

   REDEFINE GET ::getController():oModel:hBuffer[ "primer_dia_pago" ] ;
      ID       160;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::getController():oModel:hBuffer[ "segundo_dia_pago" ] ;
      ID       170;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::getController():oModel:hBuffer[ "tercer_dia_pago" ] ;
      ID       310;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::getController():oModel:hBuffer[ "mes_vacaciones" ];
      ITEMS    AMESES ;
      ID       180 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::getController():oModel:hBuffer[ "regimen_iva" ];
      ITEMS    AREGIMENIVA ;
      ID       190 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::getController():oModel:hBuffer[ "recargo_equivalencia" ] ;
      ID       200 ;
      IDSAY    202 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::getController():oModel:hBuffer[ "porcentaje_irpf" ] ;
      ID       210;
      SPINNER ;
      PICTURE  "@E 999.99" ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::getController():oModel:hBuffer[ "bloqueado" ] ;
      ID       220 ;
      IDSAY    222 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      ON CHANGE( ::changeBloqueo() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaBloqueo ; 
      VAR      ::getController():oModel:hBuffer[ "fecha_bloqueo" ] ;
      ID       230 ;
      IDSAY    232 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetCausaBloqueo ;
      VAR      ::getController():oModel:hBuffer[ "causa_bloqueo" ] ;
      ID       240 ;
      IDSAY    242 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::getController():oModel:hBuffer[ "autorizado_venta_credito" ] ;
      ID       250 ;
      IDSAY    252 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      ON CHANGE( ::changeAutorizacioncredito() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaPeticion ; 
      VAR      ::getController():oModel:hBuffer[ "fecha_peticion_riesgo" ] ;
      ID       260 ;
      IDSAY    262 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaConcesion ; 
      VAR      ::getController():oModel:hBuffer[ "fecha_concesion_riesgo" ] ;
      ID       270 ;
      IDSAY    272 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::oBloqueoRiesgo ;
      VAR      ::getController():oModel:hBuffer[ "bloquear_riesgo_alcanzado" ] ;
      ID       280 ;
      IDSAY    282 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oRiesgo ; 
      VAR      ::getController():oModel:hBuffer[ "riesgo" ] ;
      ID       290;
      IDSAY    292 ;
      SPINNER ;
      PICTURE  "@E 9999999999999999.99" ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oRiesgoAlcanzado ; 
      VAR      ::nRiesgoAlcanzado ;
      ID       300;
      IDSAY    302 ;
      PICTURE  "@E 9999999999999999.99" ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE CHECKBOX ::getController():oModel:hBuffer[ "excluir_fidelizacion" ] ;
      ID       320 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE CHECKBOX ::getController():oModel:hBuffer[ "no_editar_datos" ] ;
      ID       330 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaUltimaLlamada ;
      VAR      ::getController():oModel:hBuffer[ "fecha_ultima_llamada" ] ;
      ID       340 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   TBtnBmp():ReDefine( 350, "gc_recycle_16",,,,,{|| ::loadFechaLlamada() }, ::oFolder:aDialogs[2], .f., {|| ::getController():isNotZoomMode() }, .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD redefineContabilidad() CLASS TercerosView

   REDEFINE SAY ::oInfoSubCuenta ;
      PROMPT   "Subcuenta..." ;
      FONT     oFontBold() ; 
      COLOR    rgb( 10, 152, 234 ) ;
      ID       320 ;
      OF       ::oFolder:aDialogs[3]

   ::oInfoSubCuenta:lWantClick  := .t.
   ::oInfoSubCuenta:OnClick     := {|| if( ::getController():isNotZoomMode(),  msgalert( "Informe subcuenta del cliente" ), ) }

   REDEFINE GET ::oGetSubcuenta ; 
      VAR      ::getController():oModel:hBuffer[ "subcuenta" ] ;
      ID       330 ;
      IDTEXT   331 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      ON HELP  ( MsgInfo( "Conectar con Contaplus" ) ) ;
      BITMAP   "LUPA" ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE GET ::oSaldoSubcuenta ; 
      VAR      ::nSaldoSubcuenta ;
      ID       340;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE SAY ::oInfoSubCuenta ;
      PROMPT   "Cuenta venta" ;
      FONT     oFontBold() ; 
      COLOR    rgb( 10, 152, 234 ) ;
      ID       352 ;
      OF       ::oFolder:aDialogs[3]

   ::oInfoSubCuenta:lWantClick  := .t.
   ::oInfoSubCuenta:OnClick     := {|| if( ::getController():isNotZoomMode(),  msgalert( "Informe cuenta venta del cliente" ), ) }

   REDEFINE GET ::oGetCuentaVenta ; 
      VAR      ::getController():oModel:hBuffer[ "cuenta_venta" ] ;
      ID       350 ;
      IDTEXT   351 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
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
   ::oInfoSubCuentaDescuento:OnClick     := {|| if( ::getController():isNotZoomMode(), msgalert( "Informe subcuenta dedescuento" ), ) }

   REDEFINE GET ::oGetSubcuentaDescuento ; 
      VAR      ::getController():oModel:hBuffer[ "cuenta_venta" ] ;
      ID       370 ;
      IDTEXT   371 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      ON HELP  ( MsgInfo( "Conectar con Contaplus" ) ) ;
      BITMAP   "LUPA" ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE GET ::oSaldoSubcuentaDescuento ; 
      VAR      ::nSaldoSubcuentaDescuento ;
      ID       380;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[3]

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS TercerosView

   ::addLinksToExplorerBar()
   
   ::getController():getAgentesController():getSelector():Start()

   ::getController():getFormasPagosController():getSelector():Start()

   ::getController():getCuentasRemesaController():getSelector():Start()

   ::getController():getRutasController():getSelector():Start()

   ::getController():getClientesGruposController():getSelector():Start()

   ::getController():getDireccionesController():externalStartDialog()

   if ::getController():isClient()
      ::getController():getArticulosTarifasController():getSelector():Start()
   else
      ::getController():getArticulosTarifasController():getSelector():Hide()
   end if 

   if !::getController():oModel:hBuffer[ "bloqueado" ]
      ::oGetFechaBloqueo:Hide()
      ::oGetCausaBloqueo:Hide()
   end if

   if !::getController():oModel:hBuffer[ "autorizado_venta_credito" ]
      ::oGetFechaPeticion:Hide()
      ::oGetFechaConcesion:Hide()
      ::oBloqueoRiesgo:Hide()
      ::oRiesgo:Hide()
      ::oRiesgoAlcanzado:Hide()
   end if

   ::oGetCodigo:setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS TercerosView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::getController():isNotZoomMode()

      if ::getController():isClient
         oPanel:AddLink( "Tarifas...",          {|| ::getController():getClientesTarifasController():activateDialogView() }, ::getController():getClientesTarifasController():getImage( "16" ) )
         oPanel:AddLink( "Descuentos...",       {|| ::getController():getDescuentosController():activateDialogView( ::getController():getUuid() ) }, ::getController():getDescuentosController():getImage( "16" ) )
      end if 
      
      oPanel:AddLink( "Direcciones...",         {|| ::getController():getDireccionesController():activateDialogView() }, ::getController():getDireccionesController():getImage( "16" ) )
      oPanel:AddLink( "Contactos...",           {|| ::getController():getContactosController():activateDialogView() }, ::getController():getContactosController():getImage( "16" ) )
      oPanel:AddLink( "Cuentas bancarias...",   {|| ::getController():getCuentasBancariasController():activateDialogView() }, ::getController():getCuentasBancariasController():getImage( "16" ) )
      oPanel:AddLink( "Incidencias...",         {|| ::getController():getIncidenciasController():activateDialogView() }, ::getController():getIncidenciasController():getImage( "16" ) )
      oPanel:AddLink( "Documentos...",          {|| ::getController():getDocumentosController():activateDialogView() }, ::getController():getDocumentosController():getImage( "16" ) )
      oPanel:AddLink( "Entidades facturae...",  {|| ::getController():getClientesEntidadesController():activateDialogView() }, ::getController():getClientesEntidadesController():getImage( "16" ) )
   end if

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::getController():isNotZoomMode()
      oPanel:AddLink( "Campos extra...",        {|| ::getController:getCamposExtraValoresController():Edit( ::getController():getUuid() ) }, ::getController():getCamposExtraValoresController():getImage( "16" ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeBloqueo() CLASS TercerosView

   if ::getController():oModel:hBuffer[ "bloqueado" ]
      
      hSet( ::getController():oModel:hBuffer, "fecha_bloqueo", date() )
      ::oGetFechaBloqueo:Show()
      
      ::oGetCausaBloqueo:Show()

   else
      
      hSet( ::getController():oModel:hBuffer, "fecha_bloqueo", cTod( "" ) )
      ::oGetFechaBloqueo:Hide()

      hSet( ::getController():oModel:hBuffer, "causa_bloqueo", Space( 100 ) )
      ::oGetCausaBloqueo:Hide()

   end if

   ::oGetFechaBloqueo:Refresh()
   
   ::oGetCausaBloqueo:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD loadFechaLlamada() CLASS TercerosView

   hSet( ::getController():oModel:hBuffer, "fecha_ultima_llamada", date() )

   ::oGetFechaUltimaLlamada:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD changeAutorizacioncredito() CLASS TercerosView

   if ::getController():oModel:hBuffer[ "autorizado_venta_credito" ]
      
      ::oGetFechaPeticion:Show()
      ::oGetFechaConcesion:Show()
      ::oBloqueoRiesgo:Show()
      ::oRiesgo:Show()
      ::oRiesgoAlcanzado:Show()

   else
      
      hSet( ::getController():oModel:hBuffer, "fecha_peticion_riesgo", cTod( "" ) )
      hSet( ::getController():oModel:hBuffer, "fecha_concesion_riesgo", cTod( "" ) )
      hSet( ::getController():oModel:hBuffer, "riesgo", 0 )

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