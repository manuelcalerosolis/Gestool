#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLBaseController

   DATA oRowSet

   DATA oStatement

   METHOD New( oController )

   METHOD End()

   METHOD freeRowSet()           INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )

   METHOD freeStatement()        INLINE ( if( !empty( ::oStatement ), ( ::oStatement:free(), ::oStatement := nil ), ) )

   METHOD getRowSet()            INLINE ( ::oRowSet )

   METHOD Activate()             INLINE ( ::generateRowSet(), ::oDialogView:Activate() )
   
   METHOD setId( id )            INLINE ( ::oDialogView:setId( id ) )

   METHOD generateRowSet()

   METHOD clickingHeader( oColumn )

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

METHOD generateRowSet( cOrderBy )

   local cSql           
   local nFixLabels     := 0

   if ::oDialogView:nCantidadLabels > 1
      nFixLabels        := ::oDialogView:nUnidadesLabels
   end if 

   ::freeRowSet()

   ::freeStatement()

   cSql                 := MovimientosAlmacenLineasRepository():getSQLSentenceToLabels( ::oDialogView:nDocumentoInicio, ::oDialogView:nDocumentoFin, nFixLabels, cOrderBy )
   
   ::oStatement         := getSqlDataBase():query( cSql )      

   ::oRowSet            := ::oStatement:fetchRowSet()

   ::oRowSet:goTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD clickingHeader( oColumn )

   msgAlert( oColumn:cSortOrder, "cSortOrder" )

   ::generateRowSet( oColumn:cSortOrder )

RETURN ( Self )

//---------------------------------------------------------------------------//
