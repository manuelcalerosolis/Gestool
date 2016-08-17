#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 

//---------------------------------------------------------------------------//

Function AmazonXml( nView )

   TProductAmazonXml():New( nView ):Controller()
   TStockAmazonXml():New( nView ):Controller()

Return nil

//---------------------------------------------------------------------------//

#include "ProductAmazonXml.prg"
#include "StockAmazonXml.prg"
