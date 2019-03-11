#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLPrintController

   DATA oController

   DATA oEvents

   DATA oDialogView

   DATA aFiles                         INIT {}

   DATA cFileName

   DATA oHashList

   METHOD New( oController ) CONSTRUCTOR

   METHOD End()                        

   METHOD getController()              INLINE ( ::oController )

   METHOD getDirectory()               INLINE ( Company():getPathDocuments( ::getController():cName ) )

   METHOD setFileName( cFileName )     INLINE ( ::cFileName := cFileName )
   METHOD getFileName()                INLINE ( ::cFileName )

   METHOD getFullPathFileName()        INLINE ( ::getDirectory() + ::cFileName + if( !( ".fr3" $ lower( ::cFileName ) ), ".fr3", "" ) )

   METHOD Activate()                   INLINE ( ::buildRowSet(), ::getDialogView():Activate() )
   
   METHOD clickingHeader( oColumn )    INLINE ( ::buildRowSet( oColumn:cSortOrder ) )

   METHOD getIds()                     INLINE ( iif( !empty( ::oController ), ::oController:getIds(), {} ) )

   METHOD getFilaInicio()              INLINE ( iif( !empty( ::getDialogView() ), ::getDialogView():nFilaInicio, 0 ) )
   
   METHOD getColumnaInicio()           INLINE ( iif( !empty( ::getDialogView() ), ::getDialogView():nColumnaInicio, 0 ) )

   METHOD buildRowSet()                VIRTUAL

   METHOD loadDocuments()              

   METHOD newDocument()                VIRTUAL

   METHOD deleteDocument()             

   METHOD showDocument()               VIRTUAL

   METHOD editDocument()               VIRTUAL

   METHOD getDialogView()              VIRTUAL

   // Events-------------------------------------------------------------------

   METHOD setEvents( aEvents, bEvent )
   METHOD setEvent( cEvent, bEvent )   INLINE ( ::oEvents:set( cEvent, bEvent ) )
   METHOD fireEvent( cEvent, uValue )  INLINE ( ::oEvents:fire( cEvent, uValue ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                       := oController 

   ::oEvents                           := Events():New()   

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles                        

   ::aFiles                            := {}

   aFiles                              := directory( ::getDirectory() + "*.fr3" )

   if empty( aFiles )
      RETURN ( nil )
   end if 

   aeval( aFiles, {|aFile| aadd( ::aFiles, getFileNoExt( aFile[ 1 ] ) ) } )

   ::oEvents:fire( 'loadDocuments' )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteDocument( cFileDocument )

   if empty( cFileDocument )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   ::setFileName( cFileDocument )

   if !file( ::getFullPathFileName() )
      msgStop( "No existe el formato " + ::getFullPathFileName() )
      RETURN ( self )  
   end if 

   if !msgNoYes( "¿ Desea eliminar el formato " + ::getFullPathFileName() + " ?" )
      RETURN ( self )  
   end if 
      
   if ferase( ::getFullPathFileName() ) != 0      
      msgStop( "Error al eliminar el formato " + ::getFullPathFileName() )      
   end if 

   ::oEvents:fire( 'deleteDocument' )

   ::loadDocuments()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//