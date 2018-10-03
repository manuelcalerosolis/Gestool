#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesController FROM SQLPrintController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD showDocument()

   METHOD newDocument()

   METHOD editDocument()

   METHOD getSortedIds()

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

METHOD getSortedIds()

   if ::getDialogView():lInvertirOrden
      RETURN ( asort( ::getIds(), , , {|x,y| x > y } ) )
   end if 
   
RETURN ( asort( ::getIds(), , , {|x,y| x < y } ) )

//---------------------------------------------------------------------------//

METHOD showDocument( nDevice, cFileName, nCopies, cPrinter ) 

   local nId
   local aIds
   local oReport  
   local oWaitMeter

   if empty( nDevice ) 
      msgStop( "No hay dispositivo de salida definido" )
      RETURN ( self )  
   end if 

   if empty( cFileName ) 
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   ::setFileName( cFileName )

   aIds              := ::getSortedIds()

   oWaitMeter        := TWaitMeter():New( "Imprimiendo documento(s)", "Espere por favor..." )
   oWaitMeter:setTotal( len( aIds ) )
   oWaitMeter:Run()

   oReport           := ::oController:getReport()

   oReport:createFastReport()

   oReport:setDevice( nDevice )

   oReport:setCopies( nCopies )

   if !empty( cPrinter )
      oReport:setPrinter( cPrinter )
   end if 

   oReport:setDirectory( ::getDirectory() )
   
   oReport:setFileName( ::getFileName() )

   for each nId in aIds 

      oWaitMeter:setMessage( "Imprimiendo documento " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( len( aIds ) ) ) )

      oReport:buildRowSet( nId )

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

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD editDocument()

   local oReport  

   ::setFileName( ::getDialogView():cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   oReport           := ::oController:getReport()

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:setFileName( ::getFileName() )

   oReport:buildRowSet()

   oReport:setUserDataSet()

   if oReport:isLoad()

      oReport:Design()

      oReport:DestroyFastReport()
   
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD newDocument()

   local oReport  

   oReport           := ::oController:getReport()

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:buildRowSet()

   oReport:setUserDataSet()

   oReport:Design()

   oReport:DestroyFastReport()
   
RETURN ( self )

//---------------------------------------------------------------------------//

