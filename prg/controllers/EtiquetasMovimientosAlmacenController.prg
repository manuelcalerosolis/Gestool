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

METHOD generateRowSet()

   local cSql           

   ::freeRowSet()

   ::freeStatement()

   cSql                 := MovimientosAlmacenLineasRepository():getSQLSentenceToLabels( ::oDialogView:nDocumentoInicio, ::oDialogView:nDocumentoFin )
   
   ::oStatement         := getSqlDataBase():query( cSql )      

   ::oRowSet            := ::oStatement:fetchRowSet()

   ::oRowSet:goTop()

RETURN ( Self )

//---------------------------------------------------------------------------//
