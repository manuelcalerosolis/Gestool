#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesController FROM SQLPrintController

   DATA oReport

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD showDocument( nDevice, cFileName, nCopies, cPrinter ) 

   METHOD getFullPathPdfFileName()     INLINE ( ::getImprimirSeriesController():getFullPathPdfFileName() )

   METHOD printDocument( cFileName, nCopies ) ;
                                       INLINE ( ::showDocument( IS_PRINTER, cFileName, nCopies ) )

   METHOD screenDocument( cFileName, nCopies ) ;
                                       INLINE ( ::showDocument( IS_SCREEN, cFileName, nCopies ) )

   METHOD pdfDocument( cFileName, nCopies ) ;
                                       INLINE ( ::showDocument( IS_PDF, cFileName, nCopies ) )

   METHOD generateDocument( hGenerate )

   METHOD newDocument()

   METHOD editDocument()

   METHOD loadDocuments()              INLINE ( ::getController():loadDocuments() )

   METHOD getDocumentPrint()           INLINE ( ::getController():getDocumentPrint() )

   METHOD getCopyPrint()               INLINE ( ::getController():getCopyPrint() )

   METHOD getUuidIdentifiers()         INLINE ( hGetValues( ::getController():getIdentifiers() ) )

   METHOD getFirstUuidIdentifier()     INLINE ( hGetValueAt( ::getController():getIdentifiers(), 1 ) )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ImprimirSeriesView():New( self ), ), ::oDialogView )

   METHOD dialogViewActivate()         INLINE ( ::getDialogView():Activate() )

   METHOD createReport( hGenerate )

   METHOD createReportRowset()

   METHOD loadReportAndShow()

   METHOD loadReportAndDesign()

   METHOD freeRowSet()                 INLINE ( ::oReport:freeRowSet() )

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
      msgAlert( "Falta del device" )
      RETURN ( nil )
   end if 

   ::oReport              := ::getController():getReport()

   ::oReport:createFastReport()

   ::oReport:setDirectory( ::getDirectory() )

   ::oReport:setDevice( hget( hGenerate, "device" ) )

   if ( hhaskey( hGenerate, "fileName" ) )
      ::oReport:setFileName( hget( hGenerate, "fileName" ) )
   end if 

   if hhaskey( hGenerate, "copies" )
      ::oReport:setCopies( hget( hGenerate, "copies" ) )
   end if 

   if hhaskey( hGenerate, "printer" )
      ::oReport:setPrinter( hget( hGenerate, "printer" ) )
   end if 
   
   if hhaskey( hGenerate, "pdfFileName" )
      ::oReport:setPdfFileName( hget( hGenerate, "pdfFileName" ) )
   end if 

   if hhaskey( hGenerate, "pdfFileName" )
      ::oReport:setPdfFileName( hget( hGenerate, "pdfFileName" ) )
   end if 

RETURN ( ::oReport )

//---------------------------------------------------------------------------//

METHOD loadReportAndShow() CLASS ImprimirSeriesController

   if ::oReport:isLoad()
      ::oReport:Show()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadReportAndDesign() CLASS ImprimirSeriesController

   if ::oReport:isLoad()
      ::oReport:Design()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createReportRowSet( uuid ) CLASS ImprimirSeriesController

   ::oReport:buildRowSet( uuid )

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

   DEFAULT cFileName    := ::getController():getDocumentPrint()
   DEFAULT nCopies      := ::getController():getPrintCopy()

   ::createReport(   {  "uuid"     => ::getUuidIdentifiers(),;
                        "device"   => nDevice,;
                        "fileName" => cFileName,;
                        "copies"   => nCopies,;
                        "printer"  => cPrinter } )

   oWaitMeter           := TWaitMeter():New( "Imprimiendo documento(s)", "Espere por favor..." )
   oWaitMeter:setTotal( len( ::getUuidIdentifiers() ) )
   oWaitMeter:Run()

   for each uuidIdentifier in ::getUuidIdentifiers() 

      oWaitMeter:setMessage( "Imprimiendo documento " + hb_ntos( hb_enumindex() ) + " de " + hb_ntos( oWaitMeter:getTotal() ) )

      ::createReportRowSet( uuidIdentifier )

      ::loadReportAndShow()

      ::freeRowSet()

      oWaitMeter:autoInc()

   next

   ::destroyReport()

   oWaitMeter:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD generateDocument( hGenerate ) CLASS ImprimirSeriesController

   local uuid

   if !( hhaskey( hGenerate, "uuid" ) )
      msgStop( "No existe un uuid" )
      RETURN ( nil )
   end if 

   uuid     := hget( hGenerate, "uuid" ) 

   ::createReport( hGenerate )

   ::createReportRowSet( uuid )

   ::loadReportAndShow()
   
   ::freeRowSet()
   
   ::destroyReport()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD editDocument( cFileName ) CLASS ImprimirSeriesController

   if empty( cFileName )
      msgStop( "No hay formato definido" )
      RETURN ( nil )  
   end if 

   ::createReport(   {  "uuid"      => ::getUuidIdentifiers(),;
                        "device"    => IS_SCREEN,;
                        "fileName"  => cFileName } )

   ::createReportRowSet( ::getFirstUuidIdentifier() )

   ::loadReportAndDesign()

   ::freeRowSet()
   
   ::destroyReport()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD newDocument() CLASS ImprimirSeriesController

   ::createReport(   {  "uuid"   => ::getFirstUuidIdentifier(),;
                        "device" => IS_SCREEN } )

   ::createReportRowSet( ::getFirstUuidIdentifier() )

   ::oReport:Design()

   ::freeRowSet()

   ::destroyReport()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

