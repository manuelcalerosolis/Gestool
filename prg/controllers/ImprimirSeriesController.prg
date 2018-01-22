#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesController FROM SQLPrintController

   METHOD New()

   METHOD Activate()

   METHOD showDocument()

   METHOD newDocument()

   METHOD editDocument()

   METHOD getSortedIds()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cDirectory                        := cPatDocuments( "Movimientos almacen" )    

   ::oDialogView                       := ImprimirSeriesView():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::oDialogView:Activate()
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getSortedIds()

   if empty(::oDialogView)
      RETURN ( ::getIds() )
   end if 

   if ::oDialogView:lInvertirOrden
      RETURN ( asort( ::getIds(), , , {|x,y| x > y} ) )
   end if 
   
RETURN ( asort( ::getIds(), , , {|x,y| x < y} ) )

//---------------------------------------------------------------------------//

METHOD showDocument() 

   local nId
   local aIds
   local oReport  
   local oWaitMeter

   ::setFileName( ::oDialogView:cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   aIds        := ::getSortedIds()

   oWaitMeter  := TWaitMeter():New( "Imprimiendo documento(s)", "Espere por favor..." )
   oWaitMeter:setTotal( len( aIds ) )
   oWaitMeter:Run()

   oReport     := MovimientosAlmacenReport():New( self )

   oReport:createFastReport()

   oReport:setDevice( IS_PRINTER )

   oReport:setCopies( ::oDialogView:nCopies )

   oReport:setPrinter( ::oDialogView:cPrinter )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:setFileName( ::getFileName() )

   for each nId in aIds 

      oWaitMeter:setMessage( "Imprimiendo documento " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( len( aIds ) ) ) )

      oReport:buildRowSet( nId )

      oReport:setUserDataSet()

      if oReport:isLoad()

         oReport:Show()
     
      end if 

      oWaitMeter:autoInc()

   next

   oReport:DestroyFastReport()

   oWaitMeter:End()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD editDocument()

   local oReport  

   ::setFileName( ::oDialogView:cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   oReport  := MovimientosAlmacenReport():New( self )

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

   oReport  := MovimientosAlmacenReport():New( self )

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:buildRowSet()

   oReport:setUserDataSet()

   oReport:Design()

   oReport:DestroyFastReport()
   
RETURN ( self )

//---------------------------------------------------------------------------//

