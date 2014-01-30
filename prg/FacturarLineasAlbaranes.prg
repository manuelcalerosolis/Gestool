#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TFacturarLineasAlbaranes

   DATA cPath

   METHOD FacturarLineas( cNumAlb )

   METHOD CreaTemporales()

   METHOD DividirenPorcentaje()

   METHOD Resource()

   METHOD ActualizarAlbaran()

   METHOD GenerarFactura()

END CLASS

//---------------------------------------------------------------------------//

METHOD FacturarLineas( cNumAlb ) CLASS TFacturarLineasAlbaranes

   MsgAlert( "Entro en el método" )

   MsgAlert( cNumAlb, "Número de albarán" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaTemporales() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DividirenPorcentaje() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizarAlbaran() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GenerarFactura() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//