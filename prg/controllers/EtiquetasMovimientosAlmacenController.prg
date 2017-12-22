#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLBaseController

   DATA oRowSet

   DATA oStatement

   METHOD New( oController )

   METHOD Activate()                   INLINE ( ::generateRowSet(), ::oDialogView:Activate() )
   
   METHOD clickingHeader( oColumn )    INLINE ( ::generateRowSet( oColumn:cSortOrder ) )

   METHOD setId( id )                  INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:setId( id ), ) )

   METHOD getFilaInicio()              INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nFilaInicio, 0 ) )
   
   METHOD getColumnaInicio()           INLINE ( iif( !empty( ::oDialogView ), ::oDialogView:nColumnaInicio, 0 ) )

   METHOD validateFormatoDocumento()

   METHOD generateRowSet()

   METHOD generateLabels()

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

   local cSql           
   local nFixLabels     := 0

   if ::oDialogView:nCantidadLabels > 1
      nFixLabels        := ::oDialogView:nUnidadesLabels
   end if 

   cSql                 := MovimientosAlmacenLineasRepository():getSQLSentenceToLabels( ::oDialogView:nDocumentoInicio, ::oDialogView:nDocumentoFin, nFixLabels, cOrderBy )

   msgalert( cSql, "cSql" )

   ::oRowSet:build( cSql )

   ::oRowSet:goTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD generateLabels()

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

   oMovimientosAlmacenLabelReport:setRowSet( ::oRowSet )
   oMovimientosAlmacenLabelReport:setDevice( IS_SCREEN )
   oMovimientosAlmacenLabelReport:setReport( cReport )

   oMovimientosAlmacenLabelReport:Print()

RETURN ( Self )

//---------------------------------------------------------------------------//

