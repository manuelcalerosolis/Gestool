#include "FiveWin.Ch"
#include "Factu.ch" 

#define  NUM_IND     80

//--------------------------------------------------------------------------//

FUNCTION Reindexa()

   if lAIS()
      TDataCenter():Resource( "regenerar_indices" )
   else
      TReindex():New( oWnd(), "regenerar_indices" ):Resource()
   end if

RETURN .t.

//--------------------------------------------------------------------------//

CLASS TReindex

   CLASSDATA cFile         INIT FullCurDir() + "GstApolo.usr"

   CLASSDATA nHandle

   DATA  aLgcIndices
   DATA  aMtrIndices
   DATA  aChkIndices
   DATA  aNumIndices
   DATA  aMensajes
   DATA  aProgress
   DATA  nProgress
   DATA  nActualProgress

   DATA  cPathDat
   DATA  cPathEmp
   DATA  cPatCli
   DATA  cPatArt
   DATA  cPatPrv
   DATA  cPatAlm

   DATA  cCodEmp

   DATA  oDlg

   DATA  oMsg
   DATA  cMsg              INIT ""

   DATA  lDatos            INIT .t.
   DATA  lNotGrupo         INIT .t.
   DATA  lEmpresa          INIT .t.
   DATA  lSincroniza       INIT .t.
   DATA  lMessageEnd       INIT .t.
   DATA  lCloseAll         INIT .t.

   METHOD New( oWnd )      CONSTRUCTOR

   METHOD GenIndices()

   METHOD SelectChk( lSet )

   METHOD SetMeter( nId )

   METHOD GetMeter( nId )

   METHOD SetText( cText )

   METHOD Sincroniza()

   METHOD Resource()

   Method lCreateHandle()
   Method lCloseHandle()
   Method lFreeHandle()

END CLASS

//--------------------------------------------------------------------------//

METHOD New( oWnd, oMenuItem, cPatEmp, cPatDat )

   DEFAULT cPatEmp   := cPatEmp()
   DEFAULT cPatDat   := cPatDat()

   ::cPathEmp        := cPatEmp
   ::cPathDat        := cPatDat

   ::cCodEmp         := cCodEmp()

   ::cPatCli         := cPatEmp()
   ::cPatArt         := cPatEmp()
   ::cPatPrv         := cPatEmp()
   ::cPatAlm         := cPatEmp()

   ::aLgcIndices     := Afill( Array( 6 ), .t. )
   ::aChkIndices     := Array( 6 )
   ::aProgress       := Array( 6 )
   ::nProgress       := Afill( Array( 6 ), 0 )

   ::aMtrIndices     := Array( NUM_IND )
   ::aNumIndices     := Array( NUM_IND )
   ::aNumIndices     := Afill( ::aNumIndices, 1 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GenIndices( oMsg )

   local oError
   local oBlock
   local oObject
   local nSeconds    := Seconds()

   /*
   Cerramos todas las bases de datos-------------------------------------------
   */

   StopAutoImp()

   StopServices()

   if ::lCloseAll
      dbCloseAll()
   end if

   // oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   // BEGIN SEQUENCE

   if !Empty( oMsg )
      ::oMsg         := oMsg
   end if

   if ::oDlg != nil
      ::oDlg:Disable()
      ::oDlg:bValid  := {|| .f. }
   end if

   /*
   Ficheros Maestros - Barra 1 ------------------------------------------------
   */

   if ::aLgcIndices[ 1 ]

      // Regenraci�n de indices -----------------------------------------------

      if ::lEmpresa
         ::SetText( "Generando �ndices : Empresas", ::aProgress[ 1 ] )        ; rxEmpresa( ::cPathDat )
         ::SetText( "Generando �ndices : Usuarios", ::aProgress[ 1 ] )        ; rxUsuario( ::cPathDat )
         ::SetText( "Generando �ndices : Divisas", ::aProgress[ 1 ]  )        ; rxDiv( ::cPathDat )
         ::SetText( "Generando �ndices : Configuraci�n", ::aProgress[ 1 ] )   ; TShell():ReindexData()
         ::SetText( "Generando �ndices : Contadores", ::aProgress[ 1 ] )      ; rxCount( ::cPathDat ); synCount( ::cPathEmp )
      end if

      if ::lDatos
         ::SetText( "Generando �ndices : Tipo de " + cImp(), ::aProgress[ 1 ] )  ; rxTIva( ::cPathDat )
         ::SetText( "Generando �ndices : Movimientos", ::aProgress[ 1 ] )        ; rxTMov( ::cPathDat )
         ::SetText( "Generando �ndices : Filtros", ::aProgress[ 1 ] )            ; TFilterDatabase():Create( ::cPathDat ):Reindexa()
         ::SetText( "Generando �ndices : Notas", ::aProgress[ 1 ] )              ; TNotas():Create( ::cPathDat ):Reindexa()
         ::SetText( "Generando �ndices : Agenda", ::aProgress[ 1 ] )             ; TAgenda():Create( ::cPathDat ):Reindexa()
         ::SetText( "Generando �ndices : Codigos postales", ::aProgress[ 1 ] )   ; CodigosPostales():Create( ::cPathDat ):Reindexa()
         ::SetText( "Generando �ndices : Provincia", ::aProgress[ 1 ] )          ; Provincias():Create( ::cPathDat ):Reindexa()
         ::SetText( "Generando �ndices : Paises", ::aProgress[ 1 ] )             ; TPais():Create( ::cPathDat ):Reindexa()
         ::SetText( "Generando �ndices : Centro de coste", ::aProgress[ 1 ] )    ; TCentroCoste():Create( ::cPathDat ):Reindexa()
      end if

      ::SetText( "Generando �ndices : Familias", ::aProgress[ 1 ] )              ; rxFamilia( ::cPatArt )
      ::SetText( "Generando �ndices : Estados del SAT", ::aProgress[ 1 ] )       ; rxEstadoSat()
      ::SetText( "Generando �ndices : Tempordas", ::aProgress[ 1 ] )             ; rxTemporada( ::cPatArt )
      ::SetText( "Generando �ndices : Grupos de familias", ::aProgress[ 1 ] )    ; TGrpFam():Create( ::cPatArt ):Reindexa()
      ::SetText( "Generando �ndices : Fabricantes", ::aProgress[ 1 ] )           ; TFabricantes():Create( ::cPatArt ):Reindexa()
      ::SetText( "Generando �ndices : Grupos de clientes", ::aProgress[ 1 ] )    ; TGrpCli():Create( ::cPatCli ):Reindexa()
      ::SetText( "Generando �ndices : Grupos de proveedores", ::aProgress[ 1 ] ) ; TGrpPrv():Create( ::cPatPrv ):Reindexa()
      ::SetText( "Generando �ndices : Tipos de art�culos", ::aProgress[ 1 ] )    ; TTipArt():Create( ::cPatArt ):Reindexa()
      ::SetText( "Generando �ndices : Proyectos", ::aProgress[ 1 ] )             ; TProyecto():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Cat�logos", ::aProgress[ 1 ] )             ; TCatalogo():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Unidades de medici�n", ::aProgress[ 1 ] )  ; UniMedicion():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Transportistas", ::aProgress[ 1 ] )        ; TTrans():Create( ::cPatCli ):Reindexa()
      ::SetText( "Generando �ndices : Tipos de comandas", ::aProgress[ 1 ] )     ; TComandas():Create( ::cPatArt ):Reindexa()
      ::SetText( "Generando �ndices : Cuentas de remesas", ::aProgress[ 1 ] )          ; TCtaRem():Create( ::cPatCli ):Reindexa()
      ::SetText( "Generando �ndices : Tipo de envasado", ::aProgress[ 1 ] )            ; TFrasesPublicitarias():Create( cPatEmp() ):Reindexa()
      ::SetText( "Generando �ndices : Sala de venta", ::aProgress[ 1 ] )               ; TTpvRestaurante():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Puntos de venta", ::aProgress[ 1 ] )             ; TDetSalaVta():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Configuraci�n de informes", ::aProgress[ 1 ] )   ; TInfGen():Reindexa( ::cPathEmp )
      ::SetText( "Generando �ndices : Configuraci�n de favoritos", ::aProgress[ 1 ] )  ; rxReport( ::cPathEmp )
      ::SetText( "Generando �ndices : Impuesto IVMH", ::aProgress[ 1 ] )               ; TNewImp():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Reporting", ::aProgress[ 1 ] )                   ; TFastReportInfGen():Reindexa( ::cPathEmp )

   end if

   // Barra de progreso 2 -----------------------------------------------------

   if ::aLgcIndices[ 2 ]

      ::SetText( "Generando �ndices : Formas de pago", ::aProgress[ 2 ] )           ; rxFpago(    ::cPathEmp )
      ::SetText( "Generando �ndices : Bancos", ::aProgress[ 2 ] )                   ; TBancos():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Cuentas bancarias", ::aProgress[ 2 ] )        ; TCuentasBancarias():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Art�culos", ::aProgress[ 2 ] )                ; rxArticulo( ::cPatArt )
      ::SetText( "Generando �ndices : Clientes", ::aProgress[ 2 ] )                 ; rxClient(   ::cPatCli )
      ::SetText( "Generando �ndices : Proveedores", ::aProgress[ 2 ] )              ; rxProvee(   ::cPatPrv )
      ::SetText( "Generando �ndices : Tarifas clientes y grupos", ::aProgress[ 2 ] ); TAtipicas():Create( ::cPatCli ):Reindexa()
      ::SetText( "Generando �ndices : Ofertas", ::aProgress[ 2 ] )                  ; rxOferta(   ::cPatArt )
      ::SetText( "Generando �ndices : Propiedades", ::aProgress[ 2 ] )              ; rxPro(      ::cPatArt )
      ::SetText( "Generando �ndices : Agentes", ::aProgress[ 2 ] )                  ; rxAgentes(  ::cPatCli )
      ::SetText( "Generando �ndices : Rutas", ::aProgress[ 2 ] )                    ; rxRuta(     ::cPatCli )
      ::SetText( "Generando �ndices : Almac�n", ::aProgress[ 2 ] )                  ; rxAlmacen(  ::cPatAlm )
      ::SetText( "Generando �ndices : Documentos", ::aProgress[ 2 ] )            ; rxDocs(     ::cPathEmp )
      ::SetText( "Generando �ndices : Tarifas de precios", ::aProgress[ 2 ] )    ; rxTarifa(   ::cPatArt )
      ::SetText( "Generando �ndices : Promociones", ::aProgress[ 2 ] )           ; rxPromo(    ::cPatArt )
      ::SetText( "Generando �ndices : Ubicaciones", ::aProgress[ 2 ] )           ; rxUbi(      ::cPatAlm )

   end if

   /*
   Ficheros de Trabajo - Barra 3 ----------------------------------------------
   */

   if ::aLgcIndices[ 3 ]

      ::SetText( "Generando �ndices : Pedidos a proveedor", ::aProgress[ 3 ] );                    rxPedPrv( ::cPathEmp )
      ::SetText( "Generando �ndices : Albaranes de proveedor", ::aProgress[ 3 ] );                 rxAlbPrv( ::cPathEmp )
      ::SetText( "Generando �ndices : Facturas de proveedor", ::aProgress[ 3 ] );                  rxFacPrv( ::cPathEmp )
      ::SetText( "Generando �ndices : Facturas rectificativas de proveedor", ::aProgress[ 3 ] );   rxRctPrv( ::cPathEmp )
      ::SetText( "Generando �ndices : Recibos de proveedor", ::aProgress[ 3 ] );                   rxRecPrv( ::cPathEmp )
      ::SetText( "Generando �ndices : Presupuestos de clientes", ::aProgress[ 3 ] );               rxPreCli( ::cPathEmp )
      ::SetText( "Generando �ndices : S.A.T. de clientes", ::aProgress[ 3 ] );                     rxSatCli( ::cPathEmp )
      ::SetText( "Generando �ndices : Pedidos de clientes", ::aProgress[ 3 ] );                    rxPedCli( ::cPathEmp )
      ::SetText( "Generando �ndices : Albaranes de clientes", ::aProgress[ 3 ] );                  rxAlbCli( ::cPathEmp )
      ::SetText( "Generando �ndices : Facturas de clientes", ::aProgress[ 3 ] );                   rxFacCli( ::cPathEmp )
      ::SetText( "Generando �ndices : Facturas rectificativas", ::aProgress[ 3 ] );                rxFacRec( ::cPathEmp )
      ::SetText( "Generando �ndices : Facturas de anticipos", ::aProgress[ 3 ] );                  rxAntCli( ::cPathEmp )
      ::SetText( "Generando �ndices : Recibos de clientes", ::aProgress[ 3 ] );                    rxRecCli( ::cPathEmp )

      ::SetText( "Generando �ndices : Facturas plantillas de ventas autom�ticas", ::aProgress[ 3 ] );      TFacAutomatica():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : L�neas de plantillas de ventas autom�ticas", ::aProgress[ 3 ] );     TDetFacAutomatica():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Hist�rico de plantillas de ventas autom�ticas", ::aProgress[ 3 ] );  THisFacAutomatica():New( ::cPathEmp ):Reindexa()

      ::SetText( "Generando �ndices : Remesas bancarias", ::aProgress[ 3 ] );          TRemesas():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Envios y recepciones", ::aProgress[ 3 ] );       TSndRecInf():Reindexa( ::cPathEmp )

      ::SetText( "Generando �ndices : Campos extra", ::aProgress[ 3 ] );               TCamposExtra():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Detalles de campos extra", ::aProgress[ 3 ] );   TDetCamposExtra():New( ::cPathEmp ):Reindexa()

      ::SetText( "Generando �ndices : Secciones", ::aProgress[ 3 ] );                        TSeccion():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Tipos de horas", ::aProgress[ 3 ] );                   THoras():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Operarios", ::aProgress[ 3 ] );                        TOperarios():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Horas de operarios", ::aProgress[ 3 ] );               TDetHoras():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Operaciones", ::aProgress[ 3 ] );                      TOperacion():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Tipos de operaciones", ::aProgress[ 3 ] );             TTipOpera():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Costes maquinaria", ::aProgress[ 3 ] );                TCosMaq():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : M�quinas", ::aProgress[ 3 ] );                         TMaquina():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Detalle m�quinas", ::aProgress[ 3 ] );                 TDetCostes():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Partes de producci�n", ::aProgress[ 3 ] );             TProduccion():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : L�neas de partes de producci�n", ::aProgress[ 3 ] );   TDetProduccion():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Series de pares de producci�n", ::aProgress[ 3 ] );    TDetSeriesProduccion():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : L�neas de personal", ::aProgress[ 3 ] );               TDetPersonal():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : L�neas de horas de personal", ::aProgress[ 3 ] );      TDetHorasPersonal():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : L�neas de materias primas", ::aProgress[ 3 ] );        TDetMaterial():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Series de materias primas", ::aProgress[ 3 ] );        TDetSeriesMaterial():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : L�neas de maquinaria", ::aProgress[ 3 ] );             TDetMaquina():New( ::cPathEmp ):Reindexa()

      ::SetText( "Generando �ndices : Expediente", ::aProgress[ 3 ] );                       TExpediente():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Tipos de expedientes", ::aProgress[ 3 ] );             TTipoExpediente():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Subtipos de expediente", ::aProgress[ 3 ] );           TDetTipoExpediente():New( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Entidades", ::aProgress[ 3 ] );                        TEntidades():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Colaboradores", ::aProgress[ 3 ] );                    TColaboradores():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Actuaciones", ::aProgress[ 3 ] );                      TActuaciones():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Expedientes", ::aProgress[ 3 ] );                      TExpediente():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Actuaciones de expedientes", ::aProgress[ 3 ] );       TDetActuacion():Create( ::cPathEmp ):Reindexa()

      ::SetText( "Generando �ndices : Programas de fidelizaci�n", ::aProgress[ 3 ] );           TFideliza():Create( ::cPatArt ):Reindexa()
      ::SetText( "Generando �ndices : L�neas de programas de fidelizaci�n", ::aProgress[ 3 ] ); TDetFideliza():New( ::cPatArt ):Reindexa()

      ::SetText( "Generando �ndices : Scripts", ::aProgress[ 3 ] );                             TScripts():Create( ::cPathEmp ):Reindexa()

      ::SetText( "Generando �ndices TRemMovAlm: ", ::aProgress[ 3 ] );                          TRemMovAlm():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices TDetMovimientos: ", ::aProgress[ 3 ] );                     TDetMovimientos():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices TDetSeriesMovimientos: ", ::aProgress[ 3 ] );               TDetSeriesMovimientos():Create( ::cPathEmp ):Reindexa()

   end if

   /*
   Ficheros de TPV - Barra 4 --------------------------------------------------
   */

   if ::aLgcIndices[ 4 ]

      if ::lDatos
         ::SetText( "Generando �ndices : Cajas", ::aProgress[ 4 ] );                      rxCajas( ::cPathDat )
         ::SetText( "Generando �ndices : Impresoras de tickets", ::aProgress[ 4 ] );      rxImpTik( ::cPathDat )
         ::SetText( "Generando �ndices : Visor", ::aProgress[ 4 ] );                      rxVisor( ::cPathDat )
         ::SetText( "Generando �ndices : Caj�n Portamonedas", ::aProgress[ 4 ] );         rxCajPorta( ::cPathDat )
         ::SetText( "Generando �ndices : Capturas", ::aProgress[ 4 ] );                   TCaptura():Create( ::cPathDat ):Reindexa()
         ::SetText( "Generando �ndices : Detalle de capturas", ::aProgress[ 4 ] );        TDetCaptura():New( ::cPathDat ):Reindexa()
      end if 

      ::SetText( "Generando �ndices : invitaciones", ::aProgress[ 4 ] ) ;                 TInvitacion():Create( ::cPathEmp ):Reindexa()

      ::SetText( "Generando �ndices : Tickets de clientes", ::aProgress[ 4 ] );           rxTpv( ::cPathEmp )
      ::SetText( "Generando �ndices : Entradas y salidas", ::aProgress[ 4 ] );            rxEntSal( ::cPathEmp )
      ::SetText( "Generando �ndices : Turnos", ::aProgress[ 4 ] );                        TTurno():New( ::cPathEmp ):Reindexa():End()
      ::SetText( "Generando �ndices : Comentarios", ::aProgress[ 4 ] );                   TComentarios():Create( ::cPatArt ):Reindexa()
      ::SetText( "Generando �ndices : Lineas de comentarios", ::aProgress[ 4 ] );         TDetComentarios():Create( ::cPatArt ):Reindexa()

      ::SetText( "Generando �ndices : Ordenenes de comanda", ::aProgress[ 4 ] );          TOrdenComanda():Create( ::cPatArt ):Reindexa()

      ::SetText( "Generando �ndices : Tvp Menu", ::aProgress[ 4 ] );                      TpvMenu():Create( ::cPatArt ):Reindexa()            
      ::SetText( "Generando �ndices : Ordenenes de menu", ::aProgress[ 4 ] );             TpvMenuOrdenes():Create( ::cPatArt ):Reindexa()
      ::SetText( "Generando �ndices : Art�culos de menu", ::aProgress[ 4 ] );             TpvMenuArticulo():Create( ::cPatArt ):Reindexa()            


      ::SetText( "Generando �ndices : Log caj�n Portamonedas", ::aProgress[ 4 ] );        rxLogPorta( ::cPathEmp )
      ::SetText( "Generando �ndices : Plantillas XML", ::aProgress[ 4 ] );                TPlantillaXml():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Detalle de plantillas XML", ::aProgress[ 4 ] );     TDetCabeceraPlantillaXML():New( ::cPathEmp ):Reindexa()

      ::SetText( "Generando �ndices : Liquidaci�n de agentes", ::aProgress[ 4 ] );           TCobAge():Create( ::cPathEmp ):Reindexa()
      ::SetText( "Generando �ndices : Lineas de liquidaci�n de agentes", ::aProgress[ 4 ] ); TDetCobAge():Create( ::cPathEmp ):Reindexa()

   end if

   /*
   Syncronizando - Barra 7 ----------------------------------------------------
   */

   if ::aLgcIndices[ 6 ] .and. ::lSincroniza
      ::Sincroniza()
   end if

   if ::lMessageEnd
      MsgInfo( "Proceso finalizado con �xito, tiempo empleado : " + AllTrim( Str( Seconds() - nSeconds ) ) + " seg.", "Informaci�n" )
   end if

   // RECOVER USING oError
   //    msgStop( ErrorMessage( oError ), "Error al realizar el proceso de organizaci�n" )
   // END SEQUENCE
   // ErrorBlock( oBlock )

   if ::oDlg != nil
      ::oDlg:bValid  := {|| .t. }
      ::oDlg:Enable()
      ::oDlg:End()
   end if

   if ::lCloseAll
      dbCloseAll()
   end if

   StartAutoImp()

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD Sincroniza()

   ::SetText( "Sincroniza usuarios", ::aProgress[ 6 ] )                                ; SynUsuario()
   ::SetText( "Sincroniza bancos de clientes", ::aProgress[ 6 ] )                      ; SynClient( ::cPathEmp )
   ::SetText( "Sincroniza bancos de proveedores", ::aProgress[ 6 ] )                   ; SynProvee( ::cPathEmp )
   ::SetText( "Sincroniza art�culos", ::aProgress[ 6 ] )                               ; SynArt(    ::cPathEmp )
   ::SetText( "Sincroniza l�neas de SAT de clientes", ::aProgress[ 6 ]  )              ; SynSatCli( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de presupuestos", ::aProgress[ 6 ]  )                 ; SynPreCli( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de pedidos de clientes", ::aProgress[ 6 ]  )          ; SynPedCli( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de albaranes de clientes", ::aProgress[ 6 ]  )        ; SynAlbCli( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de facturas de clientes", ::aProgress[ 6 ]  )         ; SynFacCli( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de facturas de rectificativas", ::aProgress[ 6 ]  )   ; SynFacRec( ::cPathEmp )
   ::SetText( "Sincroniza recibos de clientes", ::aProgress[ 6 ] )                     ; SynRecCli( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de tikets de clientes", ::aProgress[ 6 ]  )           ; SynTikCli( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de pedidos a proveedor", ::aProgress[ 6 ]  )          ; SynPedPrv( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de albaranes a proveedor", ::aProgress[ 6 ]  )        ; SynAlbPrv( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de facturas a proveedor", ::aProgress[ 6 ]  )         ; SynFacPrv( ::cPathEmp )
   ::SetText( "Sincroniza l�neas de rectificativas a proveedor", ::aProgress[ 6 ]  )   ; SynRctPrv( ::cPathEmp )
   ::SetText( "Sincroniza recibos de proveedores", ::aProgress[ 6 ]  )                 ; SynRecPrv( ::cPathEmp )
   ::SetText( "Sincroniza unidades de medici�n", ::aProgress[ 6 ]  )                   ; UniMedicion():Create():Syncronize()
   ::SetText( "Sincroniza fabricantes", ::aProgress[ 6 ]  )                            ; TFabricantes():Create():Syncronize()
   ::SetText( "Sincroniza centros de coste", ::aProgress[ 6 ]  )                       ; SynCentroCoste()
   ::SetText( "Sincroniza transportistas", ::aProgress[ 6 ]  )                         ; SynTransportista( ::cPathEmp )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD SelectChk( lSet )

   local n

   for n := 1 to len( ::aLgcIndices )
      ::aLgcIndices[n] := lSet
      ::aChkIndices[n]:Refresh()
   next

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD SetMeter( nId )

   local n

   n  := aScan( ::aMtrIndices, {|o| if( o != nil, o:nId == nId, .f. ) } )

   if n != 0 .and. ::aMtrIndices[ n ] != nil
      ::aMtrIndices[ n ]:Set( 100 )
   end if

   SysRefresh()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD GetMeter( nId )

   local n  := aScan( ::aMtrIndices, {|o| o:nId == nId } )

   if n != 0 .and. ::aMtrIndices[ n ] != nil
      RETURN ( ::aMtrIndices[ n ] )
   end if

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD Resource( lAutoInit )

   local n
   local oBmp
   local nLevel 

   DEFAULT lAutoInit       := .f.

   nLevel                  := Auth():Level( "01067" )

   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      RETURN nil
   end if

   if oWnd() != nil
      oWnd():CloseAll()
   end if

   if !::lCreateHandle()
      msgStop( "Esta opci�n ya ha sido inicada por otro usuario", "Atenci�n" )
      RETURN nil
   end if

   if lAIS()
      TDataCenter():Reindex()
      RETURN nil
   end if

   /*
   Montamos el dialogo---------------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "REINDEX" OF oWnd()


      REDEFINE BITMAP oBmp RESOURCE "gc_recycle_48" ID 600 TRANSPARENT OF ::oDlg 

      REDEFINE CHECKBOX ::aChkIndices[ 1 ] VAR ::aLgcIndices[ 1 ] ID 100 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 2 ] VAR ::aLgcIndices[ 2 ] ID 101 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 3 ] VAR ::aLgcIndices[ 3 ] ID 102 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 4 ] VAR ::aLgcIndices[ 4 ] ID 103 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 5 ] VAR ::aLgcIndices[ 5 ] ID 104 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 6 ] VAR ::aLgcIndices[ 6 ] ID 105 OF ::oDlg

      ::aProgress[ 1 ]  := TApoloMeter():ReDefine( 200, { | u | if( pCount() == 0, ::nProgress[ 1 ], ::nProgress[ 1 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 2 ]  := TApoloMeter():ReDefine( 210, { | u | if( pCount() == 0, ::nProgress[ 2 ], ::nProgress[ 2 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 3 ]  := TApoloMeter():ReDefine( 220, { | u | if( pCount() == 0, ::nProgress[ 3 ], ::nProgress[ 3 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 4 ]  := TApoloMeter():ReDefine( 230, { | u | if( pCount() == 0, ::nProgress[ 4 ], ::nProgress[ 4 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 5 ]  := TApoloMeter():ReDefine( 240, { | u | if( pCount() == 0, ::nProgress[ 5 ], ::nProgress[ 5 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 6 ]  := TApoloMeter():ReDefine( 250, { | u | if( pCount() == 0, ::nProgress[ 6 ], ::nProgress[ 6 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE SAY ::oMsg PROMPT ::cMsg ID 110 OF ::oDlg

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ID 500        OF ::oDlg ACTION ( ::SelectChk( .t. ) )
      REDEFINE BUTTON ID 501        OF ::oDlg ACTION ( ::SelectChk( .f. ) )

      REDEFINE BUTTON ID IDOK       OF ::oDlg ACTION ( ::GenIndices() )
      REDEFINE BUTTON ID IDCANCEL   OF ::oDlg ACTION ( ::oDlg:end() )
      REDEFINE BUTTON ID 998        OF ::oDlg ACTION ( ChmHelp( "RegenerarIndices" ) )

      ::oDlg:AddFastKey( VK_F1, {|| ChmHelp( "RegenerarIndices" ) } )
      ::oDlg:AddFastKey( VK_F5, {|| ::GenIndices() } )

      if lAutoInit
         ::oDlg:bStart  := {|| ::GenIndices(), ::oDlg:End() }
      end if

   ACTIVATE DIALOG ::oDlg CENTER

   ::lCloseHandle()

   // Cerramos posibles tablas-------------------------------------------------

   if ::lCloseAll
      dbCloseAll()
   end if 

   // Iniciamos los servicios--------------------------------------------------

   InitServices()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetText( cText, oProgress )

   DEFAULT cText  := ""

   if !Empty( ::oMsg )
      ::oMsg:SetText( cText )
   end if

   if !Empty( oProgress )
      oProgress:Set( ++::nActualProgress )
   end if

RETURN ( Self )

//------------------------------------------------------------------------//

Method lCreateHandle()

   local nHandle

   if !file( ::cFile )
      if ( nHandle   := fCreate( ::cFile, 0 ) ) != -1
         fClose( nHandle )
      else
         msgStop( "Error " + Str( fError() ) + " al crear el fichero " + ::cFile )
      end if
   end if

   ::nHandle         := fOpen( ::cFile, 16 )

RETURN ( ::nHandle != -1 )

//---------------------------------------------------------------------------//

Method lCloseHandle()

   if !fClose( ::nHandle )
      MsgStop( "No puedo cerrar el fichero" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

Method lFreeHandle()

   local nHandle

   if !file( ::cFile )
      RETURN .t.
   end if

   if ( nHandle := fOpen( ::cFile, 16 ) ) != -1
      fClose( nHandle )
      RETURN .t.
   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//