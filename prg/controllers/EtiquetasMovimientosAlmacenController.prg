#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLPrintController

   DATA oHashList

   METHOD New( oController )

   METHOD getFilaInicio()              INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nFilaInicio, 0 ) )
   
   METHOD getColumnaInicio()           INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nColumnaInicio, 0 ) )

   METHOD buildRowSet()

   METHOD showDocument()

   METHOD editDocument()

   METHOD newDocument()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cDirectory         := cPatLabels( "Movimientos almacen" ) 

   ::oDialogView        := EtiquetasSelectorView():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD buildRowSet( cOrderBy )

   local cSentence           
   local nFixLabels     := 0

   if ::oDialogView:nCantidadLabels > 1
      nFixLabels        := ::oDialogView:nUnidadesLabels
   end if 

   cSentence            := MovimientosAlmacenLineasRepository():getSQLSentenceToLabels( ::oController:getIds(), nFixLabels, cOrderBy )

   ::oHashList          := getSQLDatabase():selectHashList( cSentence ) 

   ::oHashList:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD showDocument()

   local nRecno
   local oReport  
   local oWaitMeter

   ::setFileName( ::oDialogView:cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   oWaitMeter  := TWaitMeter():New( "Imprimiendo documento(s)", "Espere por favor..." )
   oWaitMeter:Run()

   nRecno      := ::oHashList:Recno()

   oReport     := MovimientosAlmacenLabelReport():New( self )

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )
   
   oReport:setDirectory( ::getDirectory() )

   oReport:setFileName( ::getFileName() )

   oReport:setRowSet( ::oHashList )

   oReport:setUserDataSet()

   if oReport:isLoad()

      oReport:show()

      oReport:DestroyFastReport()
   
   end if 

   ::oHashList:goTo( nRecno )

   oWaitMeter:End()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD editDocument()

   local nRecno
   local oReport  

   ::setFileName( ::oDialogView:cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   nRecno   := ::oHashList:Recno()

   oReport  := MovimientosAlmacenLabelReport():New( self )

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )

   oReport:setFileName( ::getFileName() )

   oReport:setRowSet( ::oHashList )

   oReport:setUserDataSet()

   if oReport:isLoad()

      oReport:Design()

      oReport:DestroyFastReport()
   
   end if 

   ::oHashList:goTo( nRecno )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD newDocument()

   local oReport  

   oReport  := MovimientosAlmacenLabelReport():New( self )

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:setRowSet( ::oHashList )

   oReport:setUserDataSet()

   oReport:Design()

   oReport:DestroyFastReport()
   
RETURN ( self )

//---------------------------------------------------------------------------//

