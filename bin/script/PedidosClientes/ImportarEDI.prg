#include "HbXml.ch"
#include "TDbfDbf.ch"
#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"

#define __localDirectory            "c:\EdiversaEDI\"
#define __localDirectoryPorcessed   "c:\Bestseller\Processed\"
#define __timeWait                  1

//---------------------------------------------------------------------------//

Function ImportarEDI( nView )

   ImportarPedidosClientesEDI():Run( nView )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ImportarPedidosClientesEDI

   DATA nView

   DATA aEDIFiles

   DATA oFileEDI

   DATA aTokens

   DATA hDocument
   DATA hLine

   DATA hPedidoCabecera
   DATA hPedidoLinea

   DATA seriePedido
   DATA numeroPedido
   DATA sufijoPedido

   DATA ordTipo                              INIT  {  '220' => 'Pedido normal',;
                                                      '22E' => 'Propuesta de pedido',;
                                                      '221' => 'Pedido abierto',;
                                                      '224' => 'Pedido urgente',;
                                                      '226' => 'Pedido parcial que cancela un pedido abierto',;
                                                      '227' => 'Pedido consignación',;
                                                      'YB1' => 'Pedido cross dock' }

   DATA ordFuncion                           INIT  {  '9'   => 'Original',;
                                                      '3'   => 'Cancelación',;
                                                      '5'   => 'Sustitución',;
                                                      '6'   => 'Confirmación',;
                                                      '7'   => 'Duplicado',;
                                                      '16'  => 'Propuesta',;
                                                      '31'  => 'Copia',;
                                                      '46'  => 'Provisional' }

   DATA calificadorCodigo                    INIT  {  'SA'  => 'Código de artículo interno del proveedor ',;
                                                      'IN'  => 'codigoInternoComprador',;
                                                      'BP'  => 'Código interno del comprador ',;
                                                      'SN'  => 'Número de serie ',;
                                                      'NS'  => 'Número de lote',;
                                                      'ADU' => 'Código de la unidad de embalaje ',;
                                                      'MN'  => 'Identificación interna del modelo del fabricante ',;
                                                      'DW'  => 'Identificación interna del proveedor para el dibujo ',;
                                                      'PV'  => 'Variable promocional',;
                                                      'EN'  => 'Número EAN de la unidad de expedición',;
                                                      'GB'  => 'Código de grupo de producto interno ',;
                                                      'CNA' => 'Código nacional',;
                                                      'AT'  => 'numeroBusquedaPrecio' }

   DATA calificadorDescripcion               INIT  {  'F'   => 'descripcionTextoLibre',;
                                                      'C'   => 'Descripción codificada',;
                                                      'E'   => 'Descripción corta ECI',;
                                                      'B'   => 'Código y texto' }

   DATA calificadorCantidad                  INIT  {  '21'  => 'unidadesPedidas',;
                                                      '59'  => 'Número de unidades de consumo en la unidad de expedición',;
                                                      '15E' => 'Cantidad de mercancía sin cargo',;
                                                      '61'  => 'Cantidad devuelta',;
                                                      '17E' => 'Unidades a nivel de subembalaje',;
                                                      '192' => 'Cantidad gratuita incluida TRU',;
                                                      '1'   => 'Cantidad solicitada para bonificación' }

   DATA calificadorPrecios                   INIT  {  'AAA' => 'precioNetoUnitario',;
                                                      'AAB' => 'Precio bruto unitario',;
                                                      'INF' => 'Precio a título informativo',;
                                                      'NTP' => 'Precio neto' }

   METHOD Run( nView )
   
   METHOD labelToken()                       INLINE ( ::aTokens[ 1 ] )
   METHOD say()                              INLINE ( hb_valtoexp( ::hPedidoCabecera ) )
   
   METHOD proccessEDIFiles( cEDIFiles )
   METHOD proccessEDILine()
   METHOD proccessEDITokens( aTokens )
      METHOD proccessORD()
      METHOD proccessDTM()
      METHOD proccessNADMS()                 INLINE ( ::hDocument[ "emisor" ]    := ::getField( 1 ) )
      METHOD proccessNADMR()                 INLINE ( ::hDocument[ "receptor" ]  := ::getField( 1 ) )
      METHOD proccessNADSU()
      METHOD proccessNADBY()     
      METHOD proccessNADDP()         
      METHOD proccessNADIV()
      METHOD proccessLIN()
      METHOD proccessPIALIN()
      METHOD proccessIMDLIN()
      METHOD proccessQTYLIN()
      METHOD proccessPRILIN()
      METHOD proccessLOCLIN()
      METHOD proccessTAXLIN()                INLINE ( if( !empty( ::hLine ), ::hLine[ "porcentajeImpuesto" ]  := ::getNum( 2 ), ) )
      METHOD proccessCNTRES()                

   METHOD insertLineInDcoument()

   METHOD getField( nPosition )              INLINE ( if( len( ::aTokens ) >= nPosition + 1, ::aTokens[ nPosition + 1 ], "" ) )
   METHOD getFieldTable( nPosition, hTable ) INLINE ( hget( hTable, ::getField( nPosition ) ) )
   METHOD getDate( nPosition )               INLINE ( stod( ::getField( nPosition ) ) )
   METHOD getNum( nPosition )                INLINE ( val( ::getField( nPosition ) ) )

   METHOD isbuildPedidoCliente()
   METHOD buildPedidoCliente()
   METHOD isDocumentImported()

   METHOD isClient()

   METHOD isDireccion()

   METHOD buildCabeceraPedido()

   METHOD codigoCliente()
   METHOD codigoDireccion()
   METHOD datosCliente()
   METHOD datosCabecera()
   METHOD datosBancoCliente()

   METHOD buildLineasPedido()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Run( nView ) CLASS ImportarPedidosClientesEDI 

   local aEDIFile

   ::nView           := nView

   ::aEDIFiles       := Directory( __localDirectory + "*.pla" )

   if !empty( ::aEDIFiles )
      for each aEDIFile in ::aEDIFiles
         ::ProccessEDIFiles( aEDIFile[ 1 ] )
         ::buildPedidoCliente()
      next
   else
      msgStop( "No hay ficheros en el directorio")
   end if 

   msgStop( ::say(), "proceso finalizado" )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessEDIFiles( cEDIFile )

   if !file( __localDirectory + cEDIFile )
      msgStop( __localDirectory + cEDIFile, "Fichero no existe" )
      Return .f.
   end if 

   ::hDocument          := {=>}
   ::oFileEDI           := TTxtFile():New( __localDirectory + cEDIFile )

   while ! ::oFileEDI:lEoF()
      ::proccessEDILine()
      ::oFileEDI:Skip()
   end while

   ::oFileEDI:Close()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessEDILine()

   ::aTokens              := hb_atokens( ::oFileEDI:cLine, "|" )

   if valtype( ::aTokens ) != "A" .or. len( ::aTokens ) <= 1
      Return ( nil )
   end if 

   ::proccessEDITokens()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessEDITokens()

   do case
      case ::labelToken() == "ORD"     ;  ::proccessORD()

      case ::labelToken() == "DTM"     ;  ::proccessDTM()
      
      case ::labelToken() == "NADMS"   ;  ::proccessNADMS()
      
      case ::labelToken() == "NADMR"   ;  ::proccessNADMR()

      case ::labelToken() == "NADSU"   ;  ::proccessNADSU()

      case ::labelToken() == "NADBY"   ;  ::proccessNADBY()

      case ::labelToken() == "NADDP"   ;  ::proccessNADDP()

      case ::labelToken() == "NADIV"   ;  ::proccessNADIV()

      case ::labelToken() == "LIN"     ;  ::proccessLIN()

      case ::labelToken() == "PIALIN"  ;  ::proccessPIALIN()

      case ::labelToken() == "IMDLIN"  ;  ::proccessIMDLIN()

      case ::labelToken() == "QTYLIN"  ;  ::proccessQTYLIN()

      case ::labelToken() == "LOCLIN"  ;  ::proccessLOCLIN()

      case ::labelToken() == "TAXLIN"  ;  ::proccessTAXLIN()

      case ::labelToken() == "CNTRES"  ;  ::proccessCNTRES()

   end case

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessORD()

   ::hDocument[ "documentoOrigen" ]    := ::getField( 1 )
   ::hDocument[ "tipo" ]               := ::getFieldTable( 2, ::ordTipo )
   ::hDocument[ "funcion" ]            := ::getFieldTable( 3, ::ordFuncion )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessDTM()

   ::hDocument[ "documento" ]    := ::getDate( 1 )
   ::hDocument[ "entrega" ]      := ::getDate( 2 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADSU()

   ::hDocument[ "proveedor" ]    := ::getField( 1 )
   ::hDocument[ "codprov" ]      := ::getField( 2 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADBY()

   ::hDocument[ "comprador" ]    := Padr( ::getField( 1 ), 17 )
   ::hDocument[ "departamento" ] := RJust( ::getField( 2 ), "0", 4 )
   ::hDocument[ "reposicion" ]   := ::getField( 3 )
   ::hDocument[ "sucursal" ]     := ::getField( 4 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADDP()

   ::hDocument[ "almacen" ]      := ::getField( 1 )
   ::hDocument[ "puerta" ]       := ::getField( 2 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADIV()

   ::hDocument[ "receptorFactura" ]        := ::getField( 1 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD insertLineInDcoument()

   if !empty(::hLine)

      if !hhaskey( ::hDocument, "lineas" )
         ::hDocument[ "lineas" ]       := {}         
      end if 

      aadd( ::hDocument[ "lineas" ], ::hLine )

   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessLIN()

   ::hLine                       := {=>}

   ::hLine[ "codigo" ]           := ::getField( 1 )
   ::hLine[ "tipoCodigo" ]       := ::getField( 2 )
   ::hLine[ "linea" ]            := ::getNum( 3 )

   ::insertLineInDcoument()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessPIALIN()

   local calificadorCodigo
   local referenciaArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorCodigo                  := ::getFieldTable( 1, ::calificadorCodigo )
   referenciaArticulo                 := ::getField( 2 )

   if !empty(calificadorCodigo) .and. !empty(referenciaArticulo)
      ::hLine[ calificadorCodigo ]    := referenciaArticulo
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessIMDLIN()

   local calificadorDescripcion
   local descripcionArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorDescripcion                 := ::getFieldTable( 1, ::calificadorDescripcion )
   descripcionArticulo                    := ::getNum( 2 )

   if !empty(calificadorDescripcion) .and. !empty(descripcionArticulo)
      ::hLine[ calificadorDescripcion ]  := descripcionArticulo
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessQTYLIN()

   local calificadorCantidad
   local cantidadArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorCantidad                 := ::getFieldTable( 1, ::calificadorCantidad )
   cantidadArticulo                    := ::getNum( 2 )

   if !empty(calificadorCantidad) .and. !empty(cantidadArticulo)
      ::hLine[ calificadorCantidad ]   := cantidadArticulo
   end if 

   ::hLine[ "unidadMedicion" ]         := ::getField( 3 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessPRILIN() 

   local calificadorPrecios
   local cantidadArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorPrecios                  := ::getFieldTable( 1, ::calificadorPrecios )
   cantidadArticulo                    := ::getNum( 2 )

   if !empty(calificadorPrecios) .and. !empty(cantidadArticulo)
      ::hLine[ calificadorPrecios ]    := cantidadArticulo
   end if 

   ::hLine[ "precioVenta" ]            := ::getField( 3 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessLOCLIN() 

   if empty( ::hLine )
      Return ( nil )
   end if 

   ::hLine[ "puntoEntrega" ]           := ::getField( 1 )
   ::hLine[ "unidadesEntrega" ]        := ::getField( 3 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessCNTRES()

   ::hDocument[ "numeroBultos" ]    := ::getNum( 1 ) 
   ::hDocument[ "numeroLineas" ]    := ::getNum( 4 ) 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD isbuildPedidoCliente()

   if ::isDocumentImported()
      msgStop( "El documento ya ha sido importado" )
      Return ( .f. )
   end if 

   if ::isClient()
      return ( .t. )
   end if

   if ::isDireccion()
      return ( .t. )
   end if

   msgStop( "Cliente no encontrado" )

return .f.

//-----------------------------------------------------------------------------

METHOD buildPedidoCliente()

   if ::isbuildPedidoCliente()

      ::buildCabeceraPedido()

      ::buildLineasPedido()

   end if 

   msgAlert( "Fin de la importación")

Return ( nil )

//---------------------------------------------------------------------------//

METHOD isDocumentImported()

   local isDocumentImported   := .f.

   D():getStatusPedidosClientes( ::nView )
   D():setFocusPedidosClientes( "cSuPed", ::nView )

   isDocumentImported         := ( D():PedidosClientes( ::nView ) )->( dbseek( ::hDocument[ "documentoOrigen" ] ) )

   D():setStatusPedidosClientes( ::nView )

Return ( isDocumentImported )

//---------------------------------------------------------------------------//

METHOD isClient()

   local isClient   := .f.
 
   D():getStatusClientes( ::nView )
   D():setFocusClientes( "cCodEdi", ::nView )

   isClient         := ( D():Clientes( ::nView ) )->( dbseek( ::hDocument[ "comprador" ] + Padr( ::hDocument[ "departamento" ], 4 ) ) )

   D():setStatusClientes( ::nView )

Return ( isClient )

//---------------------------------------------------------------------------//

METHOD isDireccion()

   local isDireccion   := .f.
 
   D():getStatusClientesDirecciones( ::nView )
   D():setFocusClientesDirecciones( "cCodEdi", ::nView )

   isDireccion         := ( D():ClientesDirecciones( ::nView ) )->( dbseek( ::hDocument[ "comprador" ] + ::hDocument[ "departamento" ] ) )

   D():setStatusClientesDirecciones( ::nView )

Return ( isDireccion )

//---------------------------------------------------------------------------//

METHOD codigoCliente()

   D():getStatusClientesDirecciones( ::nView )
   D():setFocusClientesDirecciones( "cCodEdi", ::nView )

   if ( D():ClientesDirecciones( ::nView ) )->( dbseek( ::hDocument[ "comprador" ] + ::hDocument[ "departamento" ] ) )

      ::hPedidoCabecera[ "Cliente" ]      := ( D():ClientesDirecciones( ::nView ) )->cCodCli

   end if

   D():setStatusClientesDirecciones( ::nView )

   if Empty( ::hPedidoCabecera[ "Cliente" ] )

      D():getStatusClientes( ::nView )
      D():setFocusClientes( "cCodEdi", ::nView )

      if ( D():Clientes( ::nView ) )->( dbseek( ::hDocument[ "receptorFactura" ] ) )

         ::hPedidoCabecera[ "Cliente" ]      := ( D():Clientes( ::nView ) )->Cod

      end if

      D():setStatusClientes( ::nView )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD codigoDireccion()

   D():getStatusClientesDirecciones( ::nView )
   D():setFocusClientesDirecciones( "cCodEdi", ::nView )

   if ( D():ClientesDirecciones( ::nView ) )->( dbseek( ::hDocument[ "comprador" ] + ::hDocument[ "departamento" ] ) )

      ::hPedidoCabecera[ "Direccion" ]    := ( D():ClientesDirecciones( ::nView ) )->cCodObr

   end if

   D():setStatusClientesDirecciones( ::nView )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD buildCabeceraPedido()

   ::hPedidoCabecera                   := D():getPedidoClienteDefaultValue( ::nView )

   ::codigoCliente()
   ::codigoDireccion()

   ::datosCliente()
   ::datosBancoCliente()

   ::datosCabecera()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD datosCabecera()

   ::numeroPedido                           := nNewDoc( ::hPedidoCabecera[ "Serie" ], D():PedidosClientes( ::nView ), "nPedCli", , D():Contadores( ::nView ) ) 
   ::sufijoPedido                           := "00"

   ::hPedidoCabecera[ "Numero"            ] := ::numeroPedido
   ::hPedidoCabecera[ "Sufijo"            ] := ::sufijoPedido
   ::hPedidoCabecera[ "Fecha"             ] := ::hDocument[ "documento" ]
   ::hPedidoCabecera[ "FechaCreacion"     ] := getSysDate()
   ::hPedidoCabecera[ "HoraCreacion"      ] := Time()
   ::hPedidoCabecera[ "DocumentoOrigen"   ] := ::hDocument[ "documentoOrigen" ]

Return ( nil )

//---------------------------------------------------------------------------//

METHOD datosCliente()

   if Empty( ::hPedidoCabecera[ "Cliente" ] )
      Return .f.
   end if

   D():getStatusClientes( ::nView )
   D():setFocusClientes( "Cod", ::nView )

   if ( D():Clientes( ::nView ) )->( dbseek( ::hPedidoCabecera[ "Cliente" ] ) )

      ::seriePedido                                  := if( Empty( ( D():Clientes( ::nView ) )->Serie ), "A", ( D():Clientes( ::nView ) )->Serie ) 

      ::hPedidoCabecera[ "NombreCliente"           ] := ( D():Clientes( ::nView ) )->Titulo
      ::hPedidoCabecera[ "DomicilioCliente"        ] := ( D():Clientes( ::nView ) )->Domicilio
      ::hPedidoCabecera[ "PoblacionCliente"        ] := ( D():Clientes( ::nView ) )->Poblacion
      ::hPedidoCabecera[ "ProvinciaCliente"        ] := ( D():Clientes( ::nView ) )->Provincia
      ::hPedidoCabecera[ "CodigoPostalCliente"     ] := ( D():Clientes( ::nView ) )->CodPostal
      ::hPedidoCabecera[ "DniCliente"              ] := ( D():Clientes( ::nView ) )->Nif
      ::hPedidoCabecera[ "TelefonoCliente"         ] := ( D():Clientes( ::nView ) )->Telefono
      ::hPedidoCabecera[ "GrupoCliente"            ] := ( D():Clientes( ::nView ) )->cCodGrp

      ::hPedidoCabecera[ "ModificarDatosCliente"   ] := ( D():Clientes( ::nView ) )->lModDat
      ::hPedidoCabecera[ "Serie"                   ] := ::seriePedido
      ::hPedidoCabecera[ "Tarifa"                  ] := ( D():Clientes( ::nView ) )->cCodTar
      ::hPedidoCabecera[ "Pago"                    ] := ( D():Clientes( ::nView ) )->CodPago
      ::hPedidoCabecera[ "Agente"                  ] := ( D():Clientes( ::nView ) )->cAgente
      ::hPedidoCabecera[ "Ruta"                    ] := ( D():Clientes( ::nView ) )->cCodRut
      ::hPedidoCabecera[ "NumeroTarifa"            ] := ( D():Clientes( ::nView ) )->nTarifa
      ::hPedidoCabecera[ "RecargoEquivalencia"     ] := ( D():Clientes( ::nView ) )->lReq
      ::hPedidoCabecera[ "OperarPuntoVerde"        ] := ( D():Clientes( ::nView ) )->lPntVer

      ::hPedidoCabecera[ "DescripcionDescuento1"   ] := ( D():Clientes( ::nView ) )->cDtoEsp
      ::hPedidoCabecera[ "PorcentajeDescuento1"    ] := ( D():Clientes( ::nView ) )->nDtoEsp
      ::hPedidoCabecera[ "DescripcionDescuento2"   ] := ( D():Clientes( ::nView ) )->cDpp
      ::hPedidoCabecera[ "PorcentajeDescuento2"    ] := ( D():Clientes( ::nView ) )->nDpp
      ::hPedidoCabecera[ "DescripcionDescuento3"   ] := ( D():Clientes( ::nView ) )->cDtoUno
      ::hPedidoCabecera[ "PorcentajeDescuento3"    ] := ( D():Clientes( ::nView ) )->nDtoCnt
      ::hPedidoCabecera[ "DescripcionDescuento4"   ] := ( D():Clientes( ::nView ) )->cDtoDos
      ::hPedidoCabecera[ "PorcentajeDescuento4"    ] := ( D():Clientes( ::nView ) )->nDtoRap

   end if

   D():setStatusClientes( ::nView )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD datosBancoCliente()

   D():getStatusClientesBancos( ::nView )
   D():setFocusClientesBancos( "cCodDef", ::nView )

   if ( D():ClientesBancos( ::nView ) )->( dbseek( ::hPedidoCabecera[ "Cliente" ] ) )

      ::hPedidoCabecera[ "NombreBanco"          ]    := ( D():ClientesBancos( ::nView ) )->cCodBnc
      ::hPedidoCabecera[ "CuentaIBAN"           ]    := ( D():ClientesBancos( ::nView ) )->cPaisIBAN
      ::hPedidoCabecera[ "DigitoControlIBAN"    ]    := ( D():ClientesBancos( ::nView ) )->cCtrlIBAN
      ::hPedidoCabecera[ "EntidadCuenta"        ]    := ( D():ClientesBancos( ::nView ) )->cEntBnc
      ::hPedidoCabecera[ "SucursalCuenta"       ]    := ( D():ClientesBancos( ::nView ) )->cSucBnc
      ::hPedidoCabecera[ "DigitoControlCuenta"  ]    := ( D():ClientesBancos( ::nView ) )->cDigBnc
      ::hPedidoCabecera[ "CuentaBancaria"       ]    := ( D():ClientesBancos( ::nView ) )->cCtaBnc

   end if

   D():setStatusClientesBancos( ::nView )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD buildLineasPedido()

   MsgInfo( "Lineas de pedidos" )

   MsgInfo( ::seriePedido, "seriePedido" )
   MsgInfo( ::numeroPedido, "numeroPedido" )
   MsgInfo( ::sufijoPedido, "sufijoPedido" )

   Msginfo( hb_valtoexp( ::hDocument[ "lineas" ][1] ) )
   MsgInfo( ValType( ::hDocument[ "lineas" ] ) )
   MsgInfo( Len( ::hDocument[ "lineas" ] ) )





return ( nil )

//---------------------------------------------------------------------------//