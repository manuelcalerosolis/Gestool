#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 

//---------------------------------------------------------------------------//

Function AmazonXml( nView, oStock )

   TProductAmazonXml():New( nView ):Controller()
   TStockAmazonXml():New( nView, oStock ):Controller()
   TPriceAmazonXml():New( nView ):Controller()
   TImagesAmazonXml():New( nView ):Controller()
  	
Return nil

//---------------------------------------------------------------------------//

#include "ProductAmazonXml.prg"
#include "StockAmazonXml.prg"
#include "PriceAmazonXml.prg"
#include "ImagesAmazonXml.prg"

