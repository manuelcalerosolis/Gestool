// TODO 
// - Establecer contador al agregar el ticket (done)
// - Crear el pago (done)
// - Controlar que el uuid ya haya sido añadido (done)
// - Eliminar los ficheros q se vayan integrando
// - Escribir un log por pantalla (done)

#include "FiveWin.Ch"
#include "Directry.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PdaEnvioRecepcionController

   CLASSDATA oInstance

   DATA nSeconds

   DATA oTimer

   DATA oDialogView

   DATA aJson

   DATA cPath

   DATA hTicketHeader

   DATA cSerieTicket       INIT "A"

   DATA cNumeroTicket   

   DATA cSufijoTicket      INIT retSufEmp()

   DATA lPrintTicket       INIT .f.

   DATA nTotalTicket
   
   DATA hTicketHeader  
   
   DATA aTicketLines 

   DATA hTicketPay

   METHOD New()
   METHOD End()

   METHOD getInstance()                INLINE ( iif( empty( ::oInstance ), ::oInstance := ::New(), ),;
                                                ::oInstance ) 
   METHOD rebuildInstance()            INLINE ( iif( !empty( ::oInstance ), ( ::oInstance:end(), ::oInstance := nil ), ),;
                                                ::getInstance() ) 

   METHOD stopTimer()
   METHOD activateTimer()

   METHOD Activate()

   METHOD exportJson()
      METHOD exportArticulosJson()
      METHOD buildArticuloJson()

      METHOD exportUsuariosJson()   
      METHOD buildUsuariosJson()

      METHOD writeJsonFile( cFileName )
      METHOD writeArticulosJson()      INLINE ( ::writeJsonFile( "articulos.json" ) )
      METHOD writeUsuariosJson()       INLINE ( ::writeJsonFile( "usuarios.json" ) )

   METHOD cFileOut( cFileName )        INLINE ( cPath( ::cPath ) + "out\" + cFileName )
   METHOD cFileProcessed( cFileName )  INLINE ( cPath( ::cPath ) + "processed\" + cFileName )
   
   METHOD importJson()
      METHOD importJsonFile( cFileName )
      METHOD isJsonProcessed( hJson )
      METHOD moveFileToProcessed( cFileName )

      METHOD getTicketCount()
      METHOD setTicketCount()

      METHOD buildTicketHeaderHash( hJson )
      METHOD buildTicketPayHash( hJson )
      METHOD buildTicketLinesHash( hJson )
         METHOD buildTicketLineHash( hLine )

      METHOD createTicket( hJson )
      METHOD createTicketLines()    
         METHOD createTicketLine( hLine )  
      METHOD createTicketPay()

      METHOD printTicket()

   METHOD setTotalProgress( nTotal )   INLINE ( iif(  !empty( ::oDialogView:oProgress ),;
                                                      ::oDialogView:oProgress:setTotal( nTotal ), ) )

   METHOD autoIncProgress()            INLINE ( iif(  !empty( ::oDialogView:oProgress ),;
                                                      ::oDialogView:oProgress:autoInc(), ) )

   METHOD deleteTreeLog( cText )       INLINE ( iif(  !empty( ::oDialogView:oTreeLog ),;
                                                      ::oDialogView:oTreeLog:deleteAll(), ) )

   METHOD addTreeLog( cText )          INLINE ( iif(  !empty( ::oDialogView:oTreeLog ),;
                                                      ::oDialogView:oTreeLog:Select( ::oDialogView:oTreeLog:Add( cText ) ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cPath                 := ConfiguracionEmpresasRepository():getValue( 'pda_ruta', '' )

   ::nSeconds              := ConfiguracionEmpresasRepository():getNumeric( 'pda_recoger_ventas', 0 )

   if !empty( ::nSeconds )
      ::oTimer             := TTimer():New( ::nSeconds * 1000, {|| ::importJson() }, ) 
      ::oTimer:hWndOwner   := GetActiveWindow()
   end if 

   ::oDialogView           := PdaEnvioRecepcionView():New( Self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oTimer )
      ::oTimer:end()
   end if 

   ::oTimer                := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::stopTimer()

   ::oDialogView:Activate()

   ::activateTimer()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD exportJson()

   ::addTreeLog( "Iniciando el proceso de exportación" )

   ::exportArticulosJson()

   ::exportUsuariosJson()

   ::addTreeLog( "Proceso de exportación finalizado" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD exportArticulosJson() 

   local cArea    := "ArtJson"

   ::aJson        := {}

   ::addTreeLog( "Exportando articulos a json" )

   ArticulosModel():getArticulosToJson( @cArea ) 

   ::setTotalProgress( ( cArea )->( lastrec() ) )

   ( cArea )->( dbgotop() )

   while !( cArea )->( eof() )

      aadd( ::aJson, ::buildArticuloJson( cArea ) )

      ::autoIncProgress()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

   ::writeArticulosJson()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildArticuloJson( cArea )

   local hJson    := {=>}
   local aCodebar := {}

   hset( hJson, "id",                           alltrim( ( cArea )->Codigo ) )
   hset( hJson, "nombre",                       alltrim( hb_oemtoansi( ( cArea )->Nombre ) ) )
   hset( hJson, "uuid",                         alltrim( ( cArea )->uuid ) )
   hset( hJson, "precio_venta",                 ( cArea )->pVenta1 )
   hset( hJson, "porcentaje_iva",               ( cArea )->tpIva )
   hset( hJson, "precio_impuestos_incluidos",   ( cArea )->pVtaIva1 )

   aadd( aCodebar, alltrim( ( cArea )->Codigo ) )

   if !empty( ( cArea )->cCodBar )
      aadd( aCodebar, alltrim( ( cArea )->cCodBar ) )
   end if 

   hset( hJson, "codigos_barras", aCodebar )

RETURN ( hJson )   

//---------------------------------------------------------------------------//

METHOD exportUsuariosJson() 

   local cArea    := "UsrJson"

   ::aJson        := {}

   ::addTreeLog( "Exportando usuarios a json" )

   UsuariosModel():getUsuariosToJson( @cArea ) 

   ::setTotalProgress( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      aadd( ::aJson, ::buildUsuariosJson( cArea ) )

      ::autoIncProgress()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

   ::writeUsuariosJson()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildUsuariosJson( cArea )

   local hJson    := {=>}

   hset( hJson, "id",      alltrim( ( cArea )->cCodUse ) )
   hset( hJson, "nombre",  alltrim( ( cArea )->cNbrUse ) )

RETURN ( hJson )   

//---------------------------------------------------------------------------//

METHOD writeJsonFile( cFileName )

   local cFile
   local cJson    := hb_jsonencode( ::aJson, .t. )

   cFile          := cPath( ::cPath ) + "in\" + cFileName

   ::addTreeLog( "Exportando fichero json " + alltrim( cFile ) )  

   if !( memowrit( cFile, cJson ) ) 
      msgStop( "Error al escribir el fichero " + alltrim( cFile ), "Error" )
   end if 

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD importJson()

   local aDirectory        := directory( cPath( ::cPath ) + "out\*.*" )

   ::setTotalProgress( len( aDirectory ) )

   ::deleteTreeLog()

   ::addTreeLog( "Inicio proceso importación" )  

   if !empty( aDirectory )
      aeval( aDirectory, {|cFileName| ::importJsonFile( cFileName[ F_NAME ] ) } )
   end if 

   ::addTreeLog( "Proceso importación finalizado" )  

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD importJsonFile( cFileName )

   local hJson

   ::addTreeLog( "Directorio de trabajo : " + cPath( ::cPath ) )

   ::autoIncProgress()

   ::addTreeLog( "Procesando : " + cFileName )

   hb_jsondecode( memoread( cPath( ::cPath ) + "out\" + cFileName ), @hJson )

   if ::isJsonProcessed( hJson )
      ::moveFileToProcessed( cFileName )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isJsonProcessed( hJson )

   if !hb_ishash( hJson )
      RETURN ( .f. )
   end if 
   
   ::nTotalTicket    := 0
   
   ::hTicketHeader   := {=>}
   
   ::aTicketLines    := {}

   ::cNumeroTicket   := ::getTicketCount()

   ::buildTicketLinesHash( hJson )

   ::buildTicketHeaderHash( hJson )

   ::buildTicketPayHash( hJson )

   if ::createTicket()

      ::setTicketCount()

      ::createTicketLines()

      ::createTicketPay()

      ::printTicket()

      RETURN ( .t. )

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getTicketCount()

   local nNumTik     := ContadoresModel():getNumeroTicket( ::cSerieTicket )

   while TicketsClientesModel():existId( ::cSerieTicket, nNumTik, ::cSufijoTicket )
      nNumTik++
   end while

RETURN ( str( nNumTik, 10 ) )

//---------------------------------------------------------------------------//

METHOD setTicketCount()

RETURN ( ContadoresModel():setNumeroTicket( ::cSerieTicket, val( ::cNumeroTicket ) + 1 ) )

//---------------------------------------------------------------------------//

METHOD buildTicketHeaderHash( hJson )

   ::addTreeLog( "Contruyendo cabecera de ticket" )

   hset( ::hTicketHeader, "cSerTik", ::cSerieTicket )
   hset( ::hTicketHeader, "cNumTik", ::cNumeroTicket )
   hset( ::hTicketHeader, "cSufTik", ::cSufijoTicket )
   hset( ::hTicketHeader, "cTurTik", cShortSesion() )
   hset( ::hTicketHeader, "cTipTik", "1" )
   hset( ::hTicketHeader, "dFecTik", ctod( substr( hget( hJson, "fecha_hora" ), 1, 10 ) ) )
   hset( ::hTicketHeader, "cHorTik", substr( hget( hJson, "fecha_hora" ), 12, 5 ) )
   hset( ::hTicketHeader, "cCcjTik", hget( hJson, "usuario" ) )
   hset( ::hTicketHeader, "cNcjTik", oUser():cCaja() )
   hset( ::hTicketHeader, "cAlmTik", oUser():cAlmacen() )
   hset( ::hTicketHeader, "cCliTik", cDefCli() )
   hset( ::hTicketHeader, "cNomTik", ClientesModel():getNombre( cDefCli() ) )
   hset( ::hTicketHeader, "nTarifa", max( uFieldEmpresa( "nPreVta" ), 1 ) )
   hset( ::hTicketHeader, "cFpgTik", cDefFpg() )
   hset( ::hTicketHeader, "cDivTik", cDivEmp() )
   hset( ::hTicketHeader, "nVdvTik", 1 )
   hset( ::hTicketHeader, "lPgdTik", .t. )
   hset( ::hTicketHeader, "lSndDoc", .t. )
   hset( ::hTicketHeader, "dFecCre", date() )
   hset( ::hTicketHeader, "cTimCre", substr( time(), 1, 5 ) )
   hset( ::hTicketHeader, "nTotTik", ::nTotalTicket )
   hset( ::hTicketHeader, "nCobTik", ::nTotalTicket )
   hset( ::hTicketHeader, "uuid",    hget( hJson, "uuid" ) )

   ::lPrintTicket       := hget( hJson, "imprimir" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildTicketLinesHash( hJson )

   ::addTreeLog( "Contruyendo líneas de ticket" )

RETURN ( aeval( hget( hJson, "lineas" ), {|hLine| ::buildTicketLineHash( hLine ) } ) )

//---------------------------------------------------------------------------//

METHOD buildTicketLineHash( hLine )
   
   local hArticulo 
   local idArticulo
   local hTicketLine 

   hTicketLine       := {=>}
   idArticulo        := cvaltochar( hget( hLine, "id_articulo" ) ) 
   hArticulo         := ArticulosModel():getHash( idArticulo )

   hset( hTicketLine, "cSerTil", ::cSerieTicket )
   hset( hTicketLine, "cNumTil", ::cNumeroTicket )
   hset( hTicketLine, "cSufTil", ::cSufijoTicket )
   hset( hTicketLine, "cTipTil", "1" )
   hset( hTicketLine, "cCbaTil", idArticulo )
   hset( hTicketLine, "nUntTil", hget( hLine, "unidades" ) )
   hset( hTicketLine, "nPvpTil", hget( hLine, "precio" ) / hget( hLine, "unidades" ) )
   hset( hTicketLine, "uuid",    hget( hLine, "uuid" ) )

   if !empty( hArticulo )
   hset( hTicketLine, "cNomTil", hget( hArticulo, "nombre" ) )
   hset( hTicketLine, "cFamTil", hget( hArticulo, "familia" ) )
   hset( hTicketLine, "nCosTil", hget( hArticulo, "pcosto" ) )
   end if 

   aadd( ::aTicketLines, hTicketLine )

   ::nTotalTicket    += hget( hLine, "unidades" ) * hget( hLine, "precio" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildTicketPayHash( hJson )
   
   ::hTicketPay      := {=>}

   hset( ::hTicketPay, "cSerTik", ::cSerieTicket )
   hset( ::hTicketPay, "cNumTik", ::cNumeroTicket )
   hset( ::hTicketPay, "cSufTik", ::cSufijoTicket )
   hset( ::hTicketPay, "cCodCaj", oUser():cCaja() )
   hset( ::hTicketPay, "dPgoTik", ctod( substr( hget( hJson, "fecha_hora" ), 1, 10 ) ) )
   hset( ::hTicketPay, "cTimTik", substr( hget( hJson, "fecha_hora" ), 12, 5 ) )
   hset( ::hTicketPay, "cFpgPgo", cDefFpg() )
   hset( ::hTicketPay, "nImpTik", ::nTotalTicket )
   hset( ::hTicketPay, "cDivPgo", cDivEmp() )
   hset( ::hTicketPay, "nVdvPgo", 1 )
   hset( ::hTicketPay, "lSndPgo", .t. )
   hset( ::hTicketPay, "cTurPgo", cShortSesion() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD createTicket()

   ::addTreeLog( "Creando ticket" )

   if TicketsClientesModel():existUuid( hget( ::hTicketHeader, "uuid" ) )
      ::addTreeLog( "Ticket ya importado : " + hget( ::hTicketHeader, "uuid" ) ) 
      RETURN ( .f. )
   end if 

   TicketsClientesModel():createFromHash( ::hTicketHeader )

   ::addTreeLog( "Ticket creado : " + hget( ::hTicketHeader, "cSerTik" ) + "/" + alltrim( hget( ::hTicketHeader, "cNumTik" ) ) + "/" + hget( ::hTicketHeader, "cSufTik" ) ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD createTicketLines()

   ::addTreeLog( "Creando lineas de ticket" )

   aeval( ::aTicketLines, {| hLine | ::createTicketLine( hLine ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createTicketLine( hLine )

   TicketsClientesLineasModel():createFromHash( hLine ) 

   ::addTreeLog( "Línea ticket creado : " + hget( hLine, "cCbaTil" ) + " - " + cvaltochar( hget( hLine, "nUntTil" ) ) + " - " + cvaltochar( hget( hLine, "nPvpTil" ) ) ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createTicketPay()

   TicketsClientesPagosModel():createFromHash( ::hTicketPay ) 

   ::addTreeLog( "Pago ticket creado : " + hget( ::hTicketPay, "cSerTik" ) + "/" + alltrim( hget( ::hTicketPay, "cNumTik" ) ) + "/" + hget( ::hTicketPay, "cSufTik" ) ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD moveFileToProcessed( cFileName )

   if copyfile( ::cFileOut( cFileName ), ::cFileProcessed( cFileName ) )
      ferase( ::cFileOut( cFileName ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD printTicket()

   if ::lPrintTicket
      prnTikCli( ::cSerieTicket + ::cNumeroTicket + ::cSufijoTicket )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD activateTimer()

   ::stopTimer()

   if !empty( ::oTimer )
      ::oTimer:Activate()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD stopTimer()

   if !empty( ::oTimer )
      ::oTimer:deactivate()
   endif

RETURN ( Self )

//---------------------------------------------------------------------------//
