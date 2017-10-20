#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenSeriesView FROM SQLBaseView

   METHOD New()

   METHOD Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtn

   DEFINE DIALOG oDlg RESOURCE "VtaNumSer" TITLE ::lblTitle() + "series de movimientos de almac�n"

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//