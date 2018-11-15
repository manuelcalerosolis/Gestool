/*
Simple esqueleto de un Servidor RestFul
*/

#include "FiveWin.Ch"

#include "hbclass.ch"
#include "error.ch"

#include "hbthread.ch"

#require "hbssl"
#require "hbhttpd"

REQUEST __HBEXTERN__HBSSL__

MEMVAR server, get, post, cookie, session

static oServer
static uthreadServer

//---------------------------------------------------------------------------//

FUNCTION StartServer()
   
   if empty( uthreadServer )
      uthreadServer  := hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @RunServer() )
   end if 

RETURN ( nil )   

//---------------------------------------------------------------------------//

FUNCTION StopServer()

   if empty( uthreadServer )
      RETURN ( nil )   
   end if 

   hb_memowrit( ".uhttpd.stop", "" )

   if !empty( oServer )
      oServer:Stop()
      oServer        := nil
   end if 

   if hb_threadQuitRequest( uthreadServer )
      uthreadServer  := nil
   end if 

RETURN ( nil )   

//---------------------------------------------------------------------------//

FUNCTION RunServer( nPort )

   local hMap
   local hConfig

   local oLogAccess
   local oLogError

   DEFAULT nPort     := 8002

   hb_vferase( ".uhttpd.stop" )

   oLogAccess        := UHttpdLog():New( "ws_access.log" )

   if ! oLogAccess:Add( "" )
      oLogAccess:Close()
      msgStop( "Access log file open error", hb_ntos( ferror() ) )
      RETURN ( nil )
   endif

   oLogError         := UHttpdLog():New( "ws_error.log" )

   if ! oLogError:Add( "" )
      oLogError:Close()
      oLogAccess:Close()
      msgStop( "Error log file open error", hb_ntos( ferror() ) )
      RETURN ( nil )
   endif

   oServer           := UHttpdNew()

   if ! oServer:Run( { ;
         "FirewallFilter"        => "", ;
         "LogAccess"             => {| m | oLogAccess:Add( m + hb_eol() ) }, ;
         "LogError"              => {| m | oLogError:Add( m + hb_eol() ) }, ;
         "Trace"                 => {| ... | qout( ... ) }, ;
         "Port"                  => nPort, ;
         "Idle"                  => {| o | iif( hb_fileexists( ".uhttpd.stop" ), ( ferase( ".uhttpd.stop" ), o:Stop() ), NIL ) }, ;
         "SSL"                   => .f., ;
         "Mount"                 => { ;
         "/hello"                => {|| UWrite( "Hello!" ) }, ;
         "/v1/clientType"        => {|| ClientHttpController():New():getJSON() }, ;
         "/v1/clientType/*"      => {| cPath | ClientHttpController():New( cPath ):getJSON() }, ;
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
