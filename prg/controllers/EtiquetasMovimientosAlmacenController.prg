#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLBaseController

   DATA oHashList

   DATA oStatement

   METHOD New( oController )

   METHOD Activate()                   INLINE ( ::generateRowSet(), ::oDialogView:Activate() )
   
   METHOD clickingHeader( oColumn )    INLINE ( ::generateRowSet( oColumn:cSortOrder ) )

   METHOD setIds( aIds )               INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:setIds( aIds ), ) )

   METHOD getFilaInicio()              INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nFilaInicio, 0 ) )
   
   METHOD getColumnaInicio()           INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nColumnaInicio, 0 ) )

   METHOD validateFormatoDocumento()

   METHOD generateRowSet()

   METHOD generateLabels()

   METHOD editLabels()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle             := "Etiquetas movimientos almacen lineas"

   ::oDialogView        := EtiquetasSelectorView():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validateFormatoDocumento()

   if DocumentosModel():exist( ::oDialogView:cFormatoLabel )

      ::oDialogView:oFormatoLabel:oHelpText:cText( DocumentosModel():getDescripWhereCodigo( ::oDialogView:cFormatoLabel ) )

      RETURN ( .t. )

   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD generateRowSet( cOrderBy )

   local cSentence           
   local nFixLabels     := 0

   if ::oDialogView:nCantidadLabels > 1
      nFixLabels        := ::oDialogView:nUnidadesLabels
   end if 

   cSentence            := MovimientosAlmacenLineasRepository():getSQLSentenceToLabels( ::oDialogView:aIds, nFixLabels, cOrderBy )

   ::oHashList          := getSQLDatabase():selectHashList( cSentence ) 

   ::oHashList:goTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD generateLabels()

   local nRecno
   local cReport
   local cFormato
   local oMovimientosAlmacenLabelReport  

   if empty( ::oDialogView:cFormatoLabel )
      msgStop( "No hay formatos por defecto" )
      RETURN ( self )  
   end if 

   cReport                          := DocumentosModel():getReportWhereCodigo( ::oDialogView:cFormatoLabel )              

   if empty( cReport )
      msgStop( "El formato esta vacio" )
      RETURN ( self )  
   end if 

   oMovimientosAlmacenLabelReport   := MovimientosAlmacenLabelReport():New( Self )

   nRecno                           := ::oHashList:Recno()

   oMovimientosAlmacenLabelReport:setRowSet( ::oHashList )
   oMovimientosAlmacenLabelReport:setDevice( IS_SCREEN )
   oMovimientosAlmacenLabelReport:setReport( cReport )

   oMovimientosAlmacenLabelReport:Print()

   ::oHashList:goTo( nRecno )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD editLabels()

   msgalert( ::oDialogView:cFormatoLabel )

RETURN ( Self )

//---------------------------------------------------------------------------//


