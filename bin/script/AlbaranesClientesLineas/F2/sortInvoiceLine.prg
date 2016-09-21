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

   local nVolumen
   local ordenAnterior        := ( dbfTmpLin )->( ordsetfocus() )

   ( dbfTmpLin )->( dbgotop() )
   while !( dbfTmpLin )->( eof() )

      nVolumen                := retFld( ( dbfTmpLin )->cCodPr1 + ( dbfTmpLin )->cValPr1, D():PropiedadesLineas( nView ), "nOrdTbl", "cCodPro" )
      ( dbfTmpLin )->nVolumen := if( Valtype( nVolumen ) != "N", 0, nVolumen )

      nVolumen                := retFld( ( dbfTmpLin )->cCodPr2 + ( dbfTmpLin )->cValPr1, D():PropiedadesLineas( nView ), "nOrdTbl", "cCodPro" )
      ( dbfTmpLin )->nBultos  := if( Valtype( nVolumen ) != "N", 0, nVolumen )

      ( dbfTmpLin )->( dbskip() )
   end while

   ( dbfTmpLin )->( ordcondset( "!Deleted()", {||!Deleted() } ) )
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

Return ( nil )

//---------------------------------------------------------------------------//