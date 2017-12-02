// TODO 
// - Establecer contador al agregar el ticket (done)
// - Crear el pago
// - Controlar que el uuid ya haya sido añadido (done)
// - Eliminar los ficheros q se vayan integrando
// - Escribir un log por pantalla (done)

#include "FiveWin.Ch"
#include "Directry.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PdaEnvioRecepcionController

   DATA oDialogView

   DATA aJson

   DATA cPath

   DATA hTicketHeader

   DATA cNumeroTicket   

   DATA nTotalTicket
   
   DATA hTicketHeader  
   
   DATA aTicketLines    

   METHOD New()
   METHOD End()

   METHOD Activate()

   METHOD exportJson()
      METHOD exportArticulosJson()
      METHOD buildArticuloJson()

      METHOD exportUsuariosJson()   
      METHOD buildUsuariosJson()

      METHOD writeJsonFile( cFileName )
      METHOD writeArticulosJson()      INLINE ( ::writeJsonFile( "articulos.json" ) )
      METHOD writeUsuariosJson()       INLINE ( ::writeJsonFile( "usuarios.json" ) )
   
   METHOD importJson()
      METHOD importJsonFile( cFileName )
      METHOD processJson( hJson )

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

   METHOD setTotalProgress( nTotal )   INLINE ( iif(  !empty( ::oDialogView ),;
                                                      ::oDialogView:oProgress:setTotal( nTotal ), ) )

   METHOD autoIncProgress()            INLINE ( iif(  !empty( ::oDialogView ),;
                                                      ::oDialogView:oProgress:autoInc(), ) )

   METHOD deleteTreeLog( cText )       INLINE ( iif(  !empty( ::oDialogView ),;
                                                      ::oDialogView:oTreeLog:deleteAll(), ) )

   METHOD addTreeLog( cText )          INLINE ( iif(  !empty( ::oDialogView ),;
                                                      ::oDialogView:oTreeLog:Select( ::oDialogView:oTreeLog:Add( cText ) ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cPath              := ConfiguracionEmpresasRepository():getValue( 'pda_ruta', '' )

   ::oDialogView        := PdaEnvioRecepcionView():New( Self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::oDialogView:Activate()

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
   hset( hJson, "nombre",                       alltrim( ( cArea )->Nombre ) )
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
   local cFileString

   cFileName      := cPath( ::cPath ) + "out\" + cFileName

   ::autoIncProgress()

   ::addTreeLog( "Procesando : " + cFileName )

   cFileString    := memoread( cFileName )

   hb_jsondecode( cFileString, @hJson )

   ::processJson( hJson )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processJson( hJson )

   if !hb_ishash( hJson )
      RETURN ( Self )
   end if 
   
   ::nTotalTicket    := 0
   
   ::hTicketHeader   := {=>}
   
   ::aTicketLines    := {}

   ::cNumeroTicket   := ::getTicketCount()

   ::buildTicketLinesHash( hJson )

   ::buildTicketHeaderHash( hJson )

   if ::createTicket()

      ::setTicketCount()

      ::createTicketLines()

      ::createTicketPay()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getTicketCount()

   local nNumTik     := ContadoresModel():getNumeroTicket( "A" )

   while TicketsClientesModel():existId( "A", nNumTik, retSufEmp() )
      nNumTik++
   end while

RETURN ( str( nNumTik, 10 ) )

//---------------------------------------------------------------------------//

METHOD setTicketCount()

RETURN ( ContadoresModel():setNumeroTicket( "A", val( ::cNumeroTicket ) + 1 ) )

//---------------------------------------------------------------------------//

METHOD buildTicketHeaderHash( hJson )

   ::addTreeLog( "Contruyendo cabecera de ticket" )

   hset( ::hTicketHeader, "cSerTik", "A" )
   hset( ::hTicketHeader, "cNumTik", ::cNumeroTicket )
   hset( ::hTicketHeader, "cSufTik", retSufEmp() )
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
   hset( ::hTicketHeader, "dFecCre", date() )
   hset( ::hTicketHeader, "cTimCre", substr( time(), 1, 5 ) )
   hset( ::hTicketHeader, "nTotTik", ::nTotalTicket )
   hset( ::hTicketHeader, "uuid",    hget( hJson, "uuid" ) )

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

   hset( hTicketLine, "cSerTil", "A" )
   hset( hTicketLine, "cNumTil", ::cNumeroTicket )
   hset( hTicketLine, "cSufTil", retSufEmp() )
   hset( hTicketLine, "cTipTil", "1" )
   hset( hTicketLine, "cCbaTil", idArticulo )
   hset( hTicketLine, "nUntTil", hget( hLine, "unidades" ) )
   hset( hTicketLine, "nPvpTil", hget( hLine, "precio" ) )
   hset( hTicketLine, "uuid",    hget( hLine, "uuid" ) )

   if !empty( hArticulo )
   hset( hTicketLine, "cNomTil", hget( hArticulo, "nombre" ) )
   hset( hTicketLine, "cFamTil", hget( hArticulo, "familia" ) )
   hset( hTicketLine, "nCosTil", hget( hArticulo, "pCosto" ) )
   end if 

   aadd( ::aTicketLines, hTicketLine )

   ::nTotalTicket    += hget( hLine, "unidades" ) * hget( hLine, "precio" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildTicketPayHash( hJson )
   
   ::hTicketPay      := {=>}

   hset( ::hTicketPay, "cSerTik", "A" )
   hset( ::hTicketPay, "cNumTik", ::cNumeroTicket )
   hset( ::hTicketPay, "cSufTik", retSufEmp() )
   hset( ::hTicketPay, "cCodCaj", oUser():cCaja() )
   hset( ::hTicketPay, "dFecTik", ctod( substr( hget( hJson, "fecha_hora" ), 1, 10 ) ) )
   hset( ::hTicketPay, "cHorTik", substr( hget( hJson, "fecha_hora" ), 12, 5 ) )
   hset( ::hTicketPay, "cFpgPgo", cDefFpg() )
   hset( ::hTicketPay, "nImpTik", ::nTotalTicket() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD createTicket()

   ::addTreeLog( "Creando ticket" )

   if TicketsClientesModel():existUuid( hget( ::hTicketHeader, "uuid" ) )
      ::oDialogView:oTreeLog:add( "Ticket ya importado : " + hget( ::hTicketHeader, "uuid" ) ) 
      RETURN ( .f. )
   end if 

   TicketsClientesModel():createFromHash( ::hTicketHeader )

   ::oDialogView:oTreeLog:add( "Ticket creado : " + hget( ::hTicketHeader, "cSerTik" ) + "/" + alltrim( hget( ::hTicketHeader, "cNumTik" ) ) + "/" + hget( ::hTicketHeader, "cSufTik" ) ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD createTicketLines()

   ::addTreeLog( "Creando lineas de ticket" )

   aeval( ::aTicketLines, {| hLine | ::createTicketLine( hLine ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createTicketLine( hLine )

   ::oDialogView:oTreeLog:add( "Linea ticket creado : " + hget( hLine, "cCbaTil" ) + " - " + cvaltochar( hget( hLine, "nUntTil" ) ) + " - " + cvaltochar( hget( hLine, "nPvpTil" ) ) ) 

   TicketsClientesLineasModel():createFromHash( hLine ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createTicketPay()

RETURN ( Self )

//---------------------------------------------------------------------------//
