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

METHOD New( oController ) CLASS ImprimirSeriesController

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ImprimirSeriesController

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

METHOD useReport() CLASS ImprimirSeriesController

   if ::oReport:isLoad()

      ::oReport:Show()
     
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//


METHOD createReportRowset( hGenerate ) CLASS ImprimirSeriesController

   ::oReport:buildRowSet( hget( hGenerate, "uuid" ) )

   ::oReport:setUserDataSet()

RETURN ( nil )

//---------------------------------------------------------------------------//
METHOD destroyReport() CLASS ImprimirSeriesController

   ::oReport:DestroyFastReport()

   ::oReport:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD showDocument( nDevice, cFileName, nCopies, cPrinter ) CLASS ImprimirSeriesController
 
   local oWaitMeter
   local uuidIdentifier

   DEFAULT cFileName    := ::getController():getDocumentoImpresion()
   DEFAULT nCopies      := ::getController():getCopiasImpresion()

   ::createReport(  { "uuid" => ::getUuidIdentifiers(),;
                      "device" => nDevice,;
                      "fileName" => cFileName,;
                      "Printer" => cPrinter } )

   oWaitMeter           := TWaitMeter():New( "Imprimiendo documento(s)", "Espere por favor..." )
   oWaitMeter:setTotal( len( ::getUuidIdentifiers() ) )
   oWaitMeter:Run()

   for each uuidIdentifier in ::getUuidIdentifiers() 

      oWaitMeter:setMessage( "Imprimiendo documento " + hb_ntos( hb_enumindex() ) + " de " + hb_ntos( oWaitMeter:getTotal() ) )

      ::createReportRowset( { "uuid" => uuidIdentifier,;
                              "device" => nDevice,;
                              "fileName" => cFileName,;
                              "Printer" => cPrinter } )

      ::useReport()

      ::freeRowset()

      oWaitMeter:autoInc()

   next

   ::destroyReport()

   oWaitMeter:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD generateDocument( hGenerate ) CLASS ImprimirSeriesController

   if !( hhaskey( hGenerate, "uuid" ) )
      msgStop("no existe un uuid de factura")
      RETURN ( nil )
   end if 

   ::oReport :=::createReport( hGenerate )
   ::createReportRowset( hGenerate )
   ::useReport()
   ::freeRowset()
   ::destroyReport()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD editDocument() CLASS ImprimirSeriesController

   local oReport  

   ::setFileName( ::getDialogView():cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( nil )  
   end if 

   ::createReport( { "uuid" => ::getUuidIdentifiers(),;
                      "fileName" => ::getDialogView():cListboxFile } )

   ::createReportRowset( { "uuid" => ::getFirstUuidIdentifier(),;
                           "fileName" => ::getDialogView():cListboxFile } )

   ::useReport()

   if oReport:isLoad()

      oReport:Design()

      oReport:DestroyFastReport()
   
   end if 

   oReport:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD newDocument() CLASS ImprimirSeriesController

   local oReport  
   ::createReport(  { "uuid" => ::getFirstUuidIdentifier(),;
                      "device" => IS_SCREEN } )

   ::createReportRowset( { "uuid" => ::getFirstUuidIdentifier(),;
                           "device" => IS_SCREEN } )

   ::useReport()

   ::destroyReport()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

