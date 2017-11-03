#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLBaseController

   DATA oRowSet

   DATA oStatement

   METHOD New( oController )

   METHOD End()

   METHOD freeRowSet()                 INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )

   METHOD freeStatement()              INLINE ( if( !empty( ::oStatement ), ( ::oStatement:free(), ::oStatement := nil ), ) )

   METHOD getRowSet()                  INLINE ( ::oRowSet )

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

   ::cTitle             := "Etiquetas movimientos almacen lineas"

   ::oDialogView        := EtiquetasSelectorView():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::freeRowSet()

   ::freeStatement()

RETURN ( nil )

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

   ::freeRowSet()

   ::freeStatement()
   
   ::oStatement         := getSqlDataBase():query( cSql )      

   ::oRowSet            := ::oStatement:fetchRowSet()

   ::oRowSet:goTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD generateLabels()

   local cReport
   local cFormato
   local oMovimientosAlmacenLabel  

   if empty( ::oDialogView:cFormatoLabel )
      msgStop( "No hay formatos por defecto" )
      RETURN ( self )  
   end if 

   cReport                          := DocumentosModel():getReportWhereCodigo( ::oDialogView:cFormatoLabel )              

   if empty( cReport )
      msgStop( "El formato esta vacio" )
      RETURN ( self )  
   end if 

   oMovimientosAlmacenLabel         := MovimientosAlmacenLabel():New( Self )

   oMovimientosAlmacenLabel:setRowSet( ::oRowSet )
   oMovimientosAlmacenLabel:setDevice( IS_SCREEN )
   oMovimientosAlmacenLabel:setReport( cReport )

   oMovimientosAlmacenLabel:Print()

   msgalert( "generateLabels" )

RETURN ( Self )

//---------------------------------------------------------------------------//

