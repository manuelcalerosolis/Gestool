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
   ( dbfTmpLin )->( ordcreate( cPatTmp() + "TmpLin.Cdx", "cRefPrp", "cRef + StrZero( val( cValPr2 ), 10 )", {|| Field->cRef + StrZero( val( Field->cValPr2), 10 ) } ) )

   ( dbfTmpLin )->( ordsetfocus( "cRefPrp" ) )
   
   ( dbfTmpLin )->( dbgotop() )
   while !( dbfTmpLin )->( eof() )
      ( dbfTmpLin )->nPosPrint := ( dbfTmpLin )->( ordkeyno() ) 
      ( dbfTmpLin )->( dbskip() )
   end while

   ( dbfTmpLin )->( ordsetfocus( ordenAnterior ) )

   ferase( cPatTmp() + "TmpLin.Cdx" )
   
   ( dbfTmpLin )->( dbgotop() )

   msgAlert( "Lineas ordenadas" )

return ( nil )

//---------------------------------------------------------------------------//