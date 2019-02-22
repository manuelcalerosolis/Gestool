#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS TercerosView FROM SQLBaseView

   DATA oTipo

   DATA aTipo                          INIT { "Cliente", "Proveedor", "Cliente/Proveedor" }
  
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

   DATA oGetSubcuenta
   DATA oGetCuentaVenta
   DATA oGetSubcuentaDescuento

   DATA oSaldoSubcuenta
   DATA nSaldoSubcuenta

   DATA oSaldoSubcuentaDescuento
   DATA nSaldoSubcuentaDescuento

   METHOD Activate()
      METHOD startActivate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::getController():oDireccionesController )

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
      ::getController():getModel():hBuffer()
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

   ::oDialog:bKeyDown      := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::getController():isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart        := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER 

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD redefineGeneral() CLASS TercerosView

   REDEFINE GET   ::oGetCodigo ;
      VAR         ::getController():getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( "@! NNNNNNNNNNNN" ) ;
      WHEN        ( ::getController():isAppendOrDuplicateMode() ) ;
      VALID       ( ::getController():validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::getController():getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( ::getController():validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetDni ;
      VAR         ::getController():getModel():hBuffer[ "dni" ] ;
      ID          120 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( CheckCif( ::oGetDni ) );
      OF          ::oFolder:aDialogs[1]

      REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:getModel():hBuffer[ "tipo" ] ;
      ID          130 ;
      ITEMS       ::aTipo;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::getController():getDireccionesController():getDialogView():ExternalRedefine( ::oFolder:aDialogs[1] )

   REDEFINE GET   ::getController():getModel():hBuffer[ "web" ] ;
      ID          140 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::getController():getModel():hBuffer[ "establecimiento" ] ;
      ID          150 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::getController():getArticulosTarifasController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "tarifa_codigo" ] ) )
   ::getController():getArticulosTarifasController():getSelector():Build( { "idGet" => 160, "idText" => 161, "idLink" => 162, "oDialog" => ::oFolder:aDialogs[1] } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD redefineComercial() CLASS TercerosView

   ::getController():getCuentasRemesaController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "cuenta_remesa_codigo" ] ) )
   ::getController():getCuentasRemesaController():getSelector():Build( { "idGet" => 110, "idText" => 111, "idLink" => 112, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getRutasController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "ruta_codigo" ] ) )
   ::getController():getRutasController():getSelector():Build( { "idGet" => 120, "idText" => 121, "idLink" => 122, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getAgentesController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "agente_codigo" ] ) )
   ::getController():getAgentesController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getTercerosGruposController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "tercero_grupo_codigo" ] ) )
   ::getController():getTercerosGruposController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[2] } )

   ::getController():getMetodosPagosController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "metodo_pago_codigo" ] ) )
   ::getController():getMetodosPagosController():getSelector():Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[2] } )

   REDEFINE GET ::getController():getModel():hBuffer[ "primer_dia_pago" ] ;
      ID       160;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::getController():getModel():hBuffer[ "segundo_dia_pago" ] ;
      ID       170;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::getController():getModel():hBuffer[ "tercer_dia_pago" ] ;
      ID       310;
      PICTURE  "99" ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::getController():getModel():hBuffer[ "mes_vacaciones" ];
      ITEMS    aMonths() ;
      ID       180 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::getController():getModel():hBuffer[ "regimen_iva" ];
      ITEMS    AREGIMENIVA ;
      ID       190 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::getController():getModel():hBuffer[ "recargo_equivalencia" ] ;
      ID       200 ;
      IDSAY    202 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::getController():getModel():hBuffer[ "porcentaje_irpf" ] ;
      ID       210;
      SPINNER ;
      PICTURE  "@E 999.99" ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::getController():getModel():hBuffer[ "bloqueado" ] ;
      ID       220 ;
      IDSAY    222 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      ON CHANGE( ::changeBloqueo() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaBloqueo ; 
      VAR      ::getController():getModel():hBuffer[ "fecha_bloqueo" ] ;
      ID       230 ;
      IDSAY    232 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetCausaBloqueo ;
      VAR      ::getController():getModel():hBuffer[ "causa_bloqueo" ] ;
      ID       240 ;
      IDSAY    242 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::getController():getModel():hBuffer[ "autorizado_venta_credito" ] ;
      ID       250 ;
      IDSAY    252 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      ON CHANGE( ::changeAutorizacioncredito() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaPeticion ; 
      VAR      ::getController():getModel():hBuffer[ "fecha_peticion_riesgo" ] ;
      ID       260 ;
      IDSAY    262 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaConcesion ; 
      VAR      ::getController():getModel():hBuffer[ "fecha_concesion_riesgo" ] ;
      ID       270 ;
      IDSAY    272 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE SAYCHECKBOX ::oBloqueoRiesgo ;
      VAR      ::getController():getModel():hBuffer[ "bloquear_riesgo_alcanzado" ] ;
      ID       280 ;
      IDSAY    282 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oRiesgo ; 
      VAR      ::getController():getModel():hBuffer[ "riesgo" ] ;
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

   REDEFINE CHECKBOX ::getController():getModel():hBuffer[ "excluir_fidelizacion" ] ;
      ID       320 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE CHECKBOX ::getController():getModel():hBuffer[ "no_editar_datos" ] ;
      ID       330 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oGetFechaUltimaLlamada ;
      VAR      ::getController():getModel():hBuffer[ "fecha_ultima_llamada" ] ;
      ID       340 ;
      SPINNER ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   TBtnBmp():ReDefine( 350, "gc_recycle_16",,,,,{|| ::loadFechaLlamada() }, ::oFolder:aDialogs[2], .f., {|| ::getController():isNotZoomMode() }, .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD redefineContabilidad() CLASS TercerosView

   REDEFINE GET ::oGetSubcuenta ; 
      VAR      ::getController():getModel():hBuffer[ "subcuenta" ] ;
      ID       330 ;
      IDTEXT   331 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE GET ::oGetCuentaVenta ; 
      VAR      ::getController():getModel():hBuffer[ "cuenta_venta" ] ;
      ID       350 ;
      IDTEXT   351 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[3]

   REDEFINE GET ::oGetSubcuentaDescuento ; 
      VAR      ::getController():getModel():hBuffer[ "cuenta_venta" ] ;
      ID       370 ;
      IDTEXT   371 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[3]

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS TercerosView

   ::addLinksToExplorerBar()
   
   ::getController():getAgentesController():getSelector():Start()

   ::getController():getDescuentosController():getSelector():Start()

   ::getController():getMetodosPagosController():getSelector():Start()

   ::getController():getCuentasRemesaController():getSelector():Start()

   ::getController():getRutasController():getSelector():Start()

   ::getController():getTercerosGruposController():getSelector():Start()

   ::getController():getArticulosTarifasController():getSelector():Start()

   if !::getController():getModelBuffer( "bloqueado" )
      ::oGetFechaBloqueo:Hide()
      ::oGetCausaBloqueo:Hide()
   end if

   if !::getController():getModelBuffer( "autorizado_venta_credito" )
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

      oPanel:AddLink( "Descuentos...",          {|| ::getController():getDescuentosController():activateDialogView( ::getController():getUuid() ) }, ::getController():getDescuentosController():getImage( "16" ) )

      oPanel:AddLink( "Direcciones...",         {|| ::getController():getDireccionesController():activateDialogView() }, ::getController():getDireccionesController():getImage( "16" ) )

      oPanel:AddLink( "Contactos...",           {|| ::getController():getContactosController():activateDialogView() }, ::getController():getContactosController():getImage( "16" ) )

      oPanel:AddLink( "Cuentas bancarias...",   {|| ::getController():getCuentasBancariasController():activateDialogView() }, ::getController():getCuentasBancariasController():getImage( "16" ) )

      oPanel:AddLink( "Incidencias...",         {|| ::getController():getIncidenciasController():activateDialogView() }, ::getController():getIncidenciasController():getImage( "16" ) )

      oPanel:AddLink( "Documentos...",          {|| ::getController():getDocumentosController():activateDialogView() }, ::getController():getDocumentosController():getImage( "16" ) )

      oPanel:AddLink( "Entidades facturae...",  {|| ::getController():getTercerosEntidadesController():activateDialogView() }, ::getController():getTercerosEntidadesController():getImage( "16" ) )

   end if

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::getController():isNotZoomMode()

      oPanel:AddLink( "Campos extra...",        {|| ::getController:getCamposExtraValoresController():Edit( ::getController():getUuid() ) }, ::getController():getCamposExtraValoresController():getImage( "16" ) )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeBloqueo() CLASS TercerosView

   if ::getController():getModelBuffer( "bloqueado" )
      
      ::getController():setModelBuffer( "fecha_bloqueo", date() )
      ::oGetFechaBloqueo:Show()
      
      ::oGetCausaBloqueo:Show()

   else
      
      ::getController():setModelBuffer( "fecha_bloqueo", ctod( "" ) )
      ::oGetFechaBloqueo:Hide()

      ::getController():setModelBuffer( "causa_bloqueo", space( 100 ) )
      ::oGetCausaBloqueo:Hide()

   end if

   ::oGetFechaBloqueo:Refresh()
   
   ::oGetCausaBloqueo:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadFechaLlamada() CLASS TercerosView

   ::getController():setModelBuffer( "fecha_ultima_llamada", date() )

   ::oGetFechaUltimaLlamada:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeAutorizacioncredito() CLASS TercerosView

   if ::getController():getModelBuffer( "autorizado_venta_credito" )
      
      ::oGetFechaPeticion:Show()
      ::oGetFechaConcesion:Show()
      ::oBloqueoRiesgo:Show()
      ::oRiesgo:Show()
      ::oRiesgoAlcanzado:Show()

   else
      
      ::getController():setModelBuffer( "fecha_peticion_riesgo", ctod( "" ) )
      ::getController():setModelBuffer( "fecha_concesion_riesgo", ctod( "" ) )
      ::getController():setModelBuffer( "riesgo", 0 )

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

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//