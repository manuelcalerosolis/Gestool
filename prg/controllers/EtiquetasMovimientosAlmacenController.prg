#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLBaseController

   DATA oRowSet

   METHOD New( oController )

   METHOD getRowSet()   INLINE ( ::oRowSet )

   METHOD Activate()    INLINE ( ::generateRowSet(), ::oDialogView:Activate() )
   
   METHOD setId( id )   INLINE ( ::oDialogView:setId( id ) )

   METHOD generateRowSet()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle             := "Etiquetas movimientos almacen lineas"

   ::oDialogView        := EtiquetasSelectorView():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD generateRowSet()

   local cSql           
   local oSelect

   if !empty( ::oRowSet )
      ::oRowSet:free()
   end if 

   cSql                 := MovimientosAlmacenLineasRepository():getSQLSentenceToLabels( ::oDialogView:nDocumentoInicio, ::oDialogView:nDocumentoFin )
   oSelect              := getSqlDataBase():query( cSql )      

   ::oRowSet            := oSelect:fetchRowSet()
   ::oRowSet:goTop()

   msgalert( cSql, "Generate")

RETURN ( Self )

//---------------------------------------------------------------------------//
