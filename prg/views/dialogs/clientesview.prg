#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientesView FROM SQLBaseView
  
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
   DATA nRiesgoAlcanzado   INIT 0

   DATA aMeses             INIT { "Ninguno", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" }
   DATA aRegimenIva        INIT { "General", "Unión Europea", "Excento", "Exportación" }

   METHOD Activate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

   METHOD startDialog()

   METHOD redefineGeneral()
   METHOD redefineComercial()
   METHOD redefineDirecciones()

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
      RESOURCE    "CONTAINER_MEDIUM" ;
      TITLE       ::LblTitle() + "cliente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_user2_48" ;
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
      PROMPT      "&General",;
                  "&Comercial",;
                  "&Direcciones";
      DIALOGS     "CLIENTE_GENERAL" ,;
                  "CLIENTE_COMERCIAL",;
                  "CLIENTE_DIRECCIONES"

   ::redefineGeneral()   

   ::redefineComercial()

   ::redefineDirecciones()

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

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( "@! NNNNNNNNNNNN" ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
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

   REDEFINE GET   ::oGetDni VAR ::oController:oModel:hBuffer[ "web" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetDni VAR ::oController:oModel:hBuffer[ "establecimiento" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "excluir_fidelizacion" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "no_editar_datos" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET ::oGetFechaUltimaLlamada ;
      VAR         ::oController:oModel:hBuffer[ "fecha_ultima_llamada" ] ;
      ID          170 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   TBtnBmp():ReDefine( 180, "gc_recycle_16",,,,,{|| ::loadFechaLlamada() }, ::oFolder:aDialogs[1], .f., , .f.,  )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD redefineComercial() CLASS ClientesView

   ::oController:oCuentasRemesasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_remesa_uuid" ] ) )
   ::oController:oCuentasRemesasController:oGetSelector:Activate( 110, 111, ::oFolder:aDialogs[2] )

   ::oController:oRutasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "ruta_uuid" ] ) )
   ::oController:oRutasController:oGetSelector:Activate( 120, 121, ::oFolder:aDialogs[2] )

   ::oController:oAgentesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "agente_uuid" ] ) )
   ::oController:oAgentesController:oGetSelector:Activate( 130, 131, ::oFolder:aDialogs[2] )

   ::oController:oClientesGruposController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente_grupo_uuid" ] ) )
   ::oController:oClientesGruposController:oGetSelector:Activate( 140, 141, ::oFolder:aDialogs[2] )

   ::oController:oFormasdePagoController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "forma_pago_uuid" ] ) )
   ::oController:oFormasdePagoController:oGetSelector:Activate( 150, 151, ::oFolder:aDialogs[2] )

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
      VALID    ( if( ( ::oController:oModel:hBuffer[ "segundo_dia_pago" ] != 0 .and. ::oController:oModel:hBuffer[ "segundo_dia_pago" ] <= ::oController:oModel:hBuffer[ "primer_dia_pago" ] ),;
                   ( msgStop( "Segundo día de pago debe ser mayor que el primero" ), .f. ),;
                   .t. ) ) ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::oController:oModel:hBuffer[ "mes_vacaciones" ];
      ITEMS    ::aMeses ;
      ID       180 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE COMBOBOX ::oController:oModel:hBuffer[ "regimen_iva" ];
      ITEMS    ::aRegimenIva ;
      ID       190 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "recargo_equivalencia" ] ;
      ID       200 ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE GET ::oController:oModel:hBuffer[ "porcentaje_irpf" ] ;
      ID       210;
      SPINNER ;
      PICTURE  "@E 999.99" ;
      WHEN     ( ::oController:isNotZoomMode() ) ;
      OF       ::oFolder:aDialogs[2]

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "bloqueado" ] ;
      ID       220 ;
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

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "autorizado_venta_credito" ] ;
      ID       250 ;
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

   REDEFINE CHECKBOX ::oBloqueoRiesgo ;
      VAR      ::oController:oModel:hBuffer[ "bloquear_riesgo_alcanzado" ] ;
      ID       280 ;
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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD redefineDirecciones() CLASS ClientesView

   local oBtnAppend
   local oBtnEdit
   local oBtnDelete

   REDEFINE BUTTON oBtnAppend ;
      ID          100 ;
      OF          ::oFolder:aDialogs[3] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:oDireccionesController:Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          110 ;
      OF          ::oFolder:aDialogs[3] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:oDireccionesController:Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          120 ;
      OF          ::oFolder:aDialogs[3] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:oDireccionesController:Delete() }

   ::oController:oDireccionesController:Activate( ::oFolder:aDialogs[3], 130 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oController:oAgentesController:oGetSelector:Start()

   ::oController:oFormasdePagoController:oGetSelector:Start()

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