#include "FiveWin.Ch"
#include "Directry.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PdaEnvioRecepcionController

   DATA oDialogView

   DATA aJson

   DATA cPath

   DATA hTicketHeader

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
      METHOD buildTicketHeaderHash( hJson )
      METHOD createTicket( hJson )      

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

   ::exportArticulosJson()

   ::exportUsuariosJson()

   msgInfo( "Proceso finalizado" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD exportArticulosJson() 

   local cArea    := "ArtJson"

   ::aJson        := {}

   ArticulosModel():getArticulosToJson( @cArea ) 

   ::oDialogView:oProgress:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      aadd( ::aJson, ::buildArticuloJson( cArea ) )

      ::oDialogView:oProgress:AutoInc()

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

   UsuariosModel():getUsuariosToJson( @cArea ) 

   ::oDialogView:oProgress:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      aadd( ::aJson, ::buildUsuariosJson( cArea ) )

      ::oDialogView:oProgress:AutoInc()

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

   local aDirectory

   aDirectory              := directory( cPath( ::cPath ) + "out\*.*" )

   if !empty( aDirectory )
      aeval( aDirectory, {|cFileName| ::importJsonFile( cFileName[ F_NAME ] ) } )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD importJsonFile( cFileName )

   local hJson
   local cFileString

   cFileString    := memoread( cPath( ::cPath ) + "out\" + cFileName )

   hb_jsondecode( cFileString, @hJson )

   ::processJson( hJson )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processJson( hJson )

   if !hb_ishash( hJson )
      RETURN ( Self )
   end if 

   if ::buildTicketHeaderHash( hJson )
      ::createTicket( hJson )
   end if 

   heval( hJson, {|k,v| msgalert( v, k ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildTicketHeaderHash( hJson )

   local nNumTik     := 0

   ::hTicketHeader   := {=>}

   nNumTik           := ContadoresModel():getNumeroTicket( "A" )
   nNumTik           := str( nNumTik, 10 )

   msgalert( ctod( substr( hget( hJson, "fecha_hora" ), 1, 10 ) ), "fecha_hora" ) 

   hset( ::hTicketHeader, "cSerTik", "A" )
   hset( ::hTicketHeader, "cNumTik", nNumTik )
   hset( ::hTicketHeader, "cSufTik", retSufEmp() )
   hset( ::hTicketHeader, "cTikTik", "1" )
   hset( ::hTicketHeader, "dFecTik", ctod( substr( hget( hJson, "fecha_hora" ), 1, 10 ) ) )
   hset( ::hTicketHeader, "cHorTik", substr( hget( hJson, "fecha_hora" ), 12, 5 ) )
   hset( ::hTicketHeader, "cCcjTik", hget( hJson, "usuario" ) )
   hset( ::hTicketHeader, "cNcjTik", oUser():cCaja() )
   hset( ::hTicketHeader, "cAlmTik", oUser():cAlmacen() )
   hset( ::hTicketHeader, "cCliTik", cDefCli() )
   hset( ::hTicketHeader, "nTarifa", max( uFieldEmpresa( "nPreVta" ), 1 ) )
   hset( ::hTicketHeader, "cFpgTik", cDefFpg() )
   hset( ::hTicketHeader, "cDivTik", cDivEmp() )
   hset( ::hTicketHeader, "nVdvTik", 1 )
   hset( ::hTicketHeader, "lPgdTik", .t. )
   hset( ::hTicketHeader, "dFecCre", date() )
   hset( ::hTicketHeader, "cTimCre", substr( time(), 1, 5 ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD createTicket( hJson )

   TicketsClientesModel():createFromHash( ::hTicketHeader )

RETURN ( Self )

//---------------------------------------------------------------------------//
