#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLPrintController

   DATA oController

   DATA oDialogView

   DATA cDirectory

   DATA cFileName

   DATA oHashList

   METHOD New( oController ) CONSTRUCTOR

   METHOD End()                        VIRTUAL

   METHOD setDirectory( cDirectory )   INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()               INLINE ( ::cDirectory )

   METHOD setFileName( cFileName )     INLINE ( ::cFileName := cFileName )
   METHOD getFileName()                INLINE ( ::cFileName )

   METHOD getFullPathFileName()        INLINE ( ::cDirectory + ::cFileName + if( !( ".fr3" $ lower( ::cFileName ) ), ".fr3", "" ) )

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

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                       := oController 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles                        := directory( ::getDirectory() + "*.fr3" )

   if empty( aFiles )
      RETURN ( self )
   end if 

   ::getDialogView():oListboxFile:setItems( {} )

   aeval( aFiles, {|aFile| ::getDialogView():oListboxFile:add( getFileNoExt( aFile[ 1 ] ) ) } )

   ::getDialogView():oListboxFile:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteDocument()

   local oReport  

   ::setFileName( ::getDialogView():cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

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

   ::loadDocuments()

RETURN ( self )

//---------------------------------------------------------------------------//
