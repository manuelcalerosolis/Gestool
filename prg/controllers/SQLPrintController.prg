#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLPrintController

   DATA oSenderController

   DATA cDirectory

   DATA cFileName

   DATA oDialogView

   DATA oHashList

   METHOD New( oController )

   METHOD setDirectory( cDirectory )   INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()               INLINE ( ::cDirectory )

   METHOD setFileName( cFileName )     INLINE ( ::cFileName := cFileName )
   METHOD getFileName()                INLINE ( ::cFileName )

   METHOD getFullPathFileName()        INLINE ( ::cDirectory + ::cFileName + if( !( ".fr3" $ lower( ::cFileName ) ), ".fr3", "" ) )

   METHOD Activate()                   INLINE ( ::buildRowSet(), ::oDialogView:Activate() )
   
   METHOD clickingHeader( oColumn )    INLINE ( ::buildRowSet( oColumn:cSortOrder ) )

   METHOD getIds()                     INLINE ( iif( !empty( ::oSenderController ), ::oSenderController:getIds(), {} ) )

   METHOD getFilaInicio()              INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nFilaInicio, 0 ) )
   
   METHOD getColumnaInicio()           INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nColumnaInicio, 0 ) )

   METHOD buildRowSet()                VIRTUAL

   METHOD loadDocuments()              

   METHOD newDocument()                VIRTUAL

   METHOD deleteDocument()             

   METHOD showDocument()               VIRTUAL

   METHOD editDocument()               VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oSenderController  := oController 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles         := directory( ::getDirectory() + "*.fr3" )

   if empty( aFiles )
      RETURN ( self )
   end if 

   ::oDialogView:oListboxFile:setItems( {} )

   aeval( aFiles, {|aFile| ::oDialogView:oListboxFile:add( getFileNoExt( aFile[ 1 ] ) ) } )

   ::oDialogView:oListboxFile:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteDocument()

   local oReport  

   ::setFileName( ::oDialogView:cListboxFile )

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
