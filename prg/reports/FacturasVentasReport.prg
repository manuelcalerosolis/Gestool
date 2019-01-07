#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS FacturasVentasReport FROM OperacionesComercialesReport

   METHOD getDocumentModel()           INLINE ( if( empty( ::oDocumentModel ), ::oDocumentModel := SQLFacturasVentasModel():New( self ), ), ::oDocumentModel )

   METHOD getLinesModel()              INLINE ( if( empty( ::oLinesModel ), ::oLinesModel := SQLFacturasVentasLineasModel():New( self ), ), ::oLinesModel )

END CLASS

//---------------------------------------------------------------------------//

