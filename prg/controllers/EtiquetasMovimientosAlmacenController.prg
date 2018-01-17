#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLBaseController

   DATA oHashList

   DATA cFileName

   METHOD New( oController )

   METHOD setDirectory( cDirectory )   INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()               INLINE ( ::cDirectory )

   METHOD setFileName( cFileName )     INLINE ( ::cFileName := cFileName )
   METHOD getFileName()                INLINE ( ::cFileName )

   METHOD getFullPathFileName()        INLINE ( ::cDirectory + ::cFileName )

   METHOD Activate()                   INLINE ( ::generateRowSet(), ::oDialogView:Activate() )
   
   METHOD clickingHeader( oColumn )    INLINE ( ::generateRowSet( oColumn:cSortOrder ) )

   METHOD getIds()                     INLINE ( iif( !empty( ::oSenderController ), ::oSenderController:getIds(), {} ) )

   METHOD getFilaInicio()              INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nFilaInicio, 0 ) )
   
   METHOD getColumnaInicio()           INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nColumnaInicio, 0 ) )

   METHOD generateRowSet()

   METHOD loadDocuments()

   METHOD generateDocument()

   METHOD editDocument()

   METHOD createDocument()

   METHOD deleteDocument()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle       := "Etiquetas movimientos almacen lineas"

   ::cDirectory   := cPatLabels( "Movimientos almacen" ) 

   ::oDialogView  := EtiquetasSelectorView():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles   := directory( ::getDirectory() + "*.fr3" )

   if empty( aFiles )
      RETURN ( self )
   end if 

   ::oDialogView:oListboxFile:aItems   := {}

   aeval( aFiles, {|aFile| ::oDialogView:oListboxFile:add( aFile[ 1 ] ) } )

   ::oDialogView:oListboxFile:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD generateRowSet( cOrderBy )

   local cSentence           
   local nFixLabels     := 0

   if ::oDialogView:nCantidadLabels > 1
      nFixLabels        := ::oDialogView:nUnidadesLabels
   end if 

   cSentence            := MovimientosAlmacenLineasRepository():getSQLSentenceToLabels( ::oSenderController:getIds(), nFixLabels, cOrderBy )

   ::oHashList          := getSQLDatabase():selectHashList( cSentence ) 

   ::oHashList:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD generateDocument()

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

   oReport:setRowSet( ::oHashList )

   oReport:setDevice( IS_SCREEN )
   
   oReport:setDirectory( ::getDirectory() )

   oReport:setFileName( ::getFileName() )

   oReport:buildData()

   if oReport:isLoad()

      oReport:show()

      oReport:DestroyFastReport()
   
   end if 

   ::oHashList:goTo( nRecno )

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

   oReport:setRowSet( ::oHashList )
   
   oReport:setDirectory( ::getDirectory() )

   oReport:setFileName( ::getFileName() )

   oReport:buildData()

   if oReport:isLoad()

      oReport:Design()

      oReport:DestroyFastReport()
   
   end if 

   ::oHashList:goTo( nRecno )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD createDocument()

   msgalert( "new label" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteDocument()

   msgalert( "new label" )

RETURN ( self )

//---------------------------------------------------------------------------//





