#include "FiveWin.Ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS LogFile

   DATA cDirectory                     

   DATA cName                          

   DATA cLogFile              

   DATA hLogFile                       INIT  -1 

   METHOD New( cName, cDirectory ) CONSTRUCTOR

   METHOD End()                        VIRTUAL

   METHOD Write( cText )               INLINE ( if( ::hLogFile != -1, fWrite( ::hLogFile, cText + CRLF ), ) )
   
   METHOD Create()                     INLINE ( ::hLogFile := fCreate( ::cLogFile ) )

   METHOD Show()                       INLINE ( winExec( "notepad" + space( 1 ) + ::cLogFile ) )

   METHOD Close()                      INLINE ( fClose( ::hLogFile ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cName, cDirectory ) CLASS LogFile

   DEFAULT cName        := "LogFile"
   DEFAULT cDirectory   := cPatLog()

   ::cName              := cName
   ::cDirectory         := cDirectory

   ::cLogFile           := ::cDirectory
   ::cLogFile           += cName
   ::cLogFile           += dtos( date() ) + strtran( time(), ":", "" ) + ".log"

RETURN ( self )

//----------------------------------------------------------------------------//

