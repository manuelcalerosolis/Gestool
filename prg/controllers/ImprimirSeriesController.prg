#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesController FROM SQLPrintController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD showDocument()

   METHOD newDocument()

   METHOD editDocument()

   METHOD getUuidIdentifiers()         INLINE ( hGetValues( ::getController():getIdentifiers() ) )

   METHOD getFirstUuidIdentifier()     INLINE ( hGetValueAt( ::getController():getIdentifiers(), 1 ) )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ImprimirSeriesView():New( self ), ), ::oDialogView )

   METHOD Activate()                   INLINE ( ::getDialogView():Activate() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cDirectory                        := cPatDocuments( oController:cName )    

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD showDocument( nDevice, cFileName, nCopies, cPrinter ) 

   local oReport  
   local oWaitMeter
   local uuidIdentifier

   if empty( nDevice ) 
      msgStop( "No hay dispositivo de salida definido" )
      RETURN ( self )  
   end if 

   if empty( cFileName ) 
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   ::setFileName( cFileName )

   oWaitMeter        := TWaitMeter():New( "Imprimiendo documento(s)", "Espere por favor..." )
   oWaitMeter:setTotal( len( ::getUuidIdentifiers() ) )
   oWaitMeter:Run()

   oReport           := ::getController():getReport()

   oReport:createFastReport()

   oReport:setDevice( nDevice )

   oReport:setCopies( nCopies )

   if !empty( cPrinter )
      oReport:setPrinter( cPrinter )
   end if 

   oReport:setDirectory( ::getDirectory() )
   
   oReport:setFileName( ::getFileName() )

   for each uuidIdentifier in ::getUuidIdentifiers() 

      oWaitMeter:setMessage( "Imprimiendo documento " + hb_ntos( hb_enumindex() ) + " de " + hb_ntos( oWaitMeter:nTotal ) )

      oReport:buildRowSet( uuidIdentifier )

      oReport:setUserDataSet()

      if oReport:isLoad()

         oReport:Show()
     
      end if 

      oReport:freeRowSet()

      oWaitMeter:autoInc()

   next

   oReport:DestroyFastReport()

   oReport:End()

   oWaitMeter:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD editDocument()

   local oReport  

   ::setFileName( ::getDialogView():cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( nil )  
   end if 

   oReport           := ::oController:getReport()

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:setFileName( ::getFileName() )

   oReport:buildRowSet( ::getFirstUuidIdentifier() )

   oReport:setUserDataSet()

   if oReport:isLoad()

      oReport:Design()

      oReport:DestroyFastReport()
   
   end if 

   oReport:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD newDocument()

   local oReport  

   oReport           := ::oController:getReport()

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:buildRowSet( ::getFirstUuidIdentifier() )

   oReport:setUserDataSet()

   oReport:Design()

   oReport:DestroyFastReport()

   oReport:End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

