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

function sortInvoiceLine( nView, aGet, dbfTmpLin, oBrwLin, dbfTblPro )

   local ordenAnterior        := ( dbfTmpLin )->( ordsetfocus() )
   local nVol

   ( dbfTmpLin )->( dbgotop() )
   while !( dbfTmpLin )->( eof() )

      nVol                    := retFld( ( dbfTmpLin )->cCodPr1 + ( dbfTmpLin )->cValPr1, dbfTblPro, "nOrdTbl", "cCodPro" )
      ( dbfTmpLin )->nVolumen := if( Valtype( nVol ) != "N", 0, nVol )

      nVol                    := retFld( ( dbfTmpLin )->cCodPr2 + ( dbfTmpLin )->cValPr1, dbfTblPro, "nOrdTbl", "cCodPro" )
      ( dbfTmpLin )->nBultos  := if( Valtype( nVol ) != "N", 0, nVol )

      ( dbfTmpLin )->( dbskip() )
   end while

   ( dbfTmpLin )->( ordcondset( "!Deleted()", {||!Deleted() } ) )
   //( dbfTmpLin )->( ordcreate( cPatTmp() + "TmpLin.Cdx", "cRefPrp", "cRef + StrZero( val( cValPr2 ), 10 )", {|| Field->cRef + StrZero( val( Field->cValPr2), 10 ) } ) )

   ( dbfTmpLin )->( ordcreate( cPatTmp() + "TmpLin.Cdx", "cRefPrp", "cRef + Str( nBultos ) + Str( nVolumen )", {|| Field->cRef + Str( Field->nBultos ) + Str( Field->nVolumen ) } ) )

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

   if !Empty( oBrwLin )
      oBrwLin:Refresh()
   end if

return ( nil )

//---------------------------------------------------------------------------//