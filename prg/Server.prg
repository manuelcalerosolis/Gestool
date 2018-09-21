/*
 Simple esqueleto de un Servidor RestFul
 Para Harbour 3.4
 (c)2017 Rafa Carmona
 En este ejemplo vamos a mostrar como mantener una DBF a traves de los verbos HTTP.
 GET  : Consulta lista de la dbf o un ID en concreto
 POST : Crear un registro
 PUT  : Modificar un registro
 DELETE : Borra un registro
*/

#include "FiveWin.Ch"

#include "hbclass.ch"
#include "error.ch"

#require "hbssl"
#require "hbhttpd"

REQUEST __HBEXTERN__HBSSL__

MEMVAR server, GET, post, cookie, session

FUNCTION RunServer( cOption, nPort )

   local hMap
   local oServer
   local hConfig

   local oLogAccess
   local oLogError

   DEFAULT cOption   := ""
   DEFAULT nPort     := 8002

   if cOption == "stop"
      hb_memowrit( ".uhttpd.stop", "" )
      RETURN ( nil )
   else
      hb_vferase( ".uhttpd.stop" )
   endif

   oLogAccess  := UHttpdLog():New( "ws_access.log" )

   if ! oLogAccess:Add( "" )
      oLogAccess:Close()
      msgStop( "Access log file open error", hb_ntos( ferror() ) )
      RETURN ( nil )
   endif

   oLogError   := UHttpdLog():New( "ws_error.log" )

   if ! oLogError:Add( "" )
      oLogError:Close()
      oLogAccess:Close()
      msgStop( "Error log file open error", hb_ntos( ferror() ) )
      RETURN ( nil )
   endif

   oServer           := UHttpdNew()
   // oServer:lHasSSL   := .f.

   IF ! oServer:Run( { ;
         "FirewallFilter"        => "", ;
         "LogAccess"             => {| m | oLogAccess:Add( m + hb_eol() ) }, ;
         "LogError"              => {| m | oLogError:Add( m + hb_eol() ) }, ;
         "Trace"                 => {| ... | qout( ... ) }, ;
         "Port"                  => nPort, ;
         "Idle"                  => {| o | iif( hb_fileexists( ".uhttpd.stop" ), ( ferase( ".uhttpd.stop" ), o:Stop() ), NIL ) }, ;
         "SSL"                   => .f., ;
         "Mount"                 => { ;
         "/hello"                => {|| UWrite( "Hello!" ) }, ;
         "/test"                 => {|| hb_jsonEncode( { "id" => 1, "name" => "Manuel" }, .t. ) }, ;
         "/info"                 => {|| UProcInfo() }, ;
         "/files/*"              => {| x | qout( hb_dirbase() + "/files/" + X ), UProcFiles( hb_dirbase() + "/files/" + X, .F. ) }, ;
         "/"                     => {|| URedirect( "/info" ) } } } )

      oLogError:Close()
      oLogAccess:Close()
      msgStop( oServer:cError, "Server error :" )
      ErrorLevel( 1 )
      RETURN ( nil )
   endif

   oLogError:Close()
   oLogAccess:Close()

RETURN ( nil )
