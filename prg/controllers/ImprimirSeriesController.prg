#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesController FROM SQLPrintController

   DATA oReport

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD showDocument( nDevice, cFileName, nCopies, cPrinter ) 

   METHOD generateDocument( uuidIdentifier, nDevice, cFileName, nCopies, cPrinter ) 

   METHOD printDocument( cFileName, nCopies ) ;
                                       INLINE ( ::showDocument( IS_PRINTER, cFileName, nCopies ) )

   METHOD screenDocument( cFileName, nCopies ) ;
                                       INLINE ( ::showDocument( IS_SCREEN, cFileName, nCopies ) )

   METHOD pdfDocument( cFileName, nCopies ) ;
                                       INLINE ( ::showDocument( IS_PDF, cFileName, nCopies ) )

   METHOD newDocument()

   METHOD editDocument()

   METHOD getUuidIdentifiers()         INLINE ( hGetValues( ::getController():getIdentifiers() ) )

   METHOD getFirstUuidIdentifier()     INLINE ( hGetValueAt( ::getController():getIdentifiers(), 1 ) )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ImprimirSeriesView():New( self ), ), ::oDialogView )

   METHOD dialogViewActivate()         INLINE ( ::getDialogView():Activate() )

   METHOD createReport( hGenerate )

   METHOD createReportRowset()

   METHOD useReport()

   METHOD freeRowset()                 INLINE( ::oReport:freeRowSet() )

   METHOD destroyReport()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createReport( hGenerate ) CLASS ImprimirSeriesController

   if !( hhaskey( hGenerate, "device" ) )
      RETURN ( nil )
   end if 

   if !( hhaskey( hGenerate, "fileName" ) )
      RETURN ( nil )
   end if 

   ::oReport              := ::getController():getReport()

   ::oReport:createFastReport()

   ::oReport:setDirectory( ::getDirectory() )

   ::oReport:setDevice( hget( hGenerate, "device" ) )

   ::oReport:setFileName( hget( hGenerate, "fileName" ) )

   if hhaskey( hGenerate, "copies" )
      ::oReport:setCopies( hget( hGenerate, "copies" ) )
   end if 

   if hhaskey( hGenerate, "printer" )
      ::oReport:setPrinter( hget( hGenerate, "printer" ) )
   end if 
   
   if hhaskey( hGenerate, "pdfFileName" )
      ::oReport:setPdfFileName( hget( hGenerate, "pdfFileName" ) )
   end if 

RETURN ( ::oReport )

//---------------------------------------------------------------------------//

METHOD useReport()

   if ::oReport:isLoad()

      ::oReport:Show()
     
   end if 

RETURN ( nil )

METHOD createReportRowset( hGenerate )

   ::oReport:buildRowSet( hget( hGenerate, "uuid" ) )

   ::oReport:setUserDataSet()

   if ::oReport:isLoad()

      ::oReport:Show()
     
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
METHOD destroyReport( oReport ) CLASS ImprimirSeriesController

   ::oReport:DestroyFastReport()

   ::oReport:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD showDocument( nDevice, cFileName, nCopies, cPrinter ) 

   local oWaitMeter
   local uuidIdentifier

   DEFAULT cFileName    := ::getController():getDocumentoImpresion()
   DEFAULT nCopies      := ::getController():getCopiasImpresion()

   oWaitMeter           := TWaitMeter():New( "Imprimiendo documento(s)", "Espere por favor..." )
   oWaitMeter:setTotal( len( ::getUuidIdentifiers() ) )
   oWaitMeter:Run()

   ::oReport := ::createReport( {  "device" => nDevice,;
                                   "fileName" => cFileName } )

   for each uuidIdentifier in ::getUuidIdentifiers() 

      oWaitMeter:setMessage( "Imprimiendo documento " + hb_ntos( hb_enumindex() ) + " de " + hb_ntos( oWaitMeter:getTotal() ) )


      ::createReportRowset( {  "uuid" => uuidIdentifier,;
                               "device" => nDevice,;
                               "fileName" => cFileName } )

      oWaitMeter:autoInc()

   next

   ::destroyReport()

   oWaitMeter:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD generateDocument( hGenerate )  

   if !( hhaskey( hGenerate, "uuid" ) )
      msgStop("no existe un uuid de factura")
      RETURN ( nil )
   end if 

   ::oReport :=::createReport( hGenerate )
   ::createReportRowset( hGenerate )

   ::destroyReport()

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

