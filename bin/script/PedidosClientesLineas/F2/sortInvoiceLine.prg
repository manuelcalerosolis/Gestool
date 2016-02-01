#include "FiveWin.Ch"
#include "HbXml.ch"
#include "TDbfDbf.ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

function sortInvoiceLine( nView, aGet, dbfTmpLin )

   local ordenAnterior        := ( dbfTmpLin )->( ordsetfocus() )

   ( dbfTmpLin )->( ordcondset( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpLin )->( ordcreate( cPatTmp() + "TmpLin.Cdx", "cRefPrp", "cRef + cCodPr2", {|| Field->cRef + Field->cCodPr2 } ) )

   ( dbfTmpLin )->( ordsetfocus( "cRefPrp" ) )
   
   ( dbfTmpLin )->( dbgotop() )
   while !( dbfTmpLin )->( eof() )
      ( dbfTmpLin )->nPosPrint := ( dbfTmpLin )->( ordkeyno() ) 
      ( dbfTmpLin )->( dbskip() )
   end while

   ( dbfTmpLin )->( ordsetfocus( ordenAnterior ) )

   ferase( cPatTmp() + "TmpLin.Cdx" )
   
   msgAlert( "sortInvoiceLine" )

return ( nil )

//---------------------------------------------------------------------------//

