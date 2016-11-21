#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioStock FROM TComercioConector

   DATA  TComercio

   DATA  oWaitMeter

   DATA  hProductsToUpdate                   INIT {=>}
   
   DATA  aStockProducts                      INIT {}
   DATA  aInactiveProducts                   INIT {}

   METHOD resetProductsToUpdateStocks()      INLINE ( ::hProductsToUpdate := {=>} )
   METHOD getProductsToUpadateStocks()       INLINE ( ::hProductsToUpdate )

   // External methods---------------------------------------------------------

   METHOD updateAllProductStocks()

   METHOD resetStockProducts()               INLINE ( ::aStockProducts := {} )
   METHOD resetInactiveProduct()             INLINE ( ::aInactiveProducts := {} )

   METHOD appendProductsToUpadateStocks()
      METHOD insertProductsToUpadateStocks() 

   METHOD updateWebProductStocks() 

   METHOD proccessInactivePrestashop()

   // Internal methods---------------------------------------------------------

   METHOD updateProductStocks( cWebName, aProductsWeb )
   METHOD buildInformationStockProductArray( aProducts )
   METHOD buildAddInformacionStockProductPrestashop( hProduct ) 
      METHOD proccessStockPrestashop() 
         METHOD setStockPrestashop( hStockProductData )

   METHOD idProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty )

   METHOD evalProductsToStock()              

END CLASS

//---------------------------------------------------------------------------//

METHOD updateAllProductStocks( startIdProduct )

   ::resetProductsToUpdateStocks()

   ::oProductDatabase():ordsetfocus( "lWebShop" )
   
   if ::oProductDatabase():seek( startIdProduct )

      while ( alltrim( ::oProductDatabase():cWebShop ) == ::getCurrentWebName() ) .and. !( ::oProductDatabase():eof() )

         ::writeText( alltrim( ::oProductDatabase():Codigo ) + space( 1 ) + alltrim( ::oProductDatabase():Nombre ) )

         ::insertProductsToUpadateStocks( ::oProductDatabase():Codigo, ::getCurrentWebName() ) 

         ::oProductDatabase():Skip()

      end while

   else 

      msgStop( ::getCurrentWebName(), 'no encontrado' )

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD appendProductsToUpadateStocks( idProduct, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty, nView ) 

   local cWebShop

   if !( D():gotoArticulos( idProduct, nView ) )
      Return ( .f. )
   end if 

   if !( D():Articulos( nView ) )->lPubInt
      Return ( .f. )
   end if 

   cWebShop          := alltrim( ( D():Articulos( nView ) )->cWebShop )
   
Return ( ::insertProductsToUpadateStocks(idProduct, cWebShop, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty ) )   

//---------------------------------------------------------------------------//

METHOD insertProductsToUpadateStocks( idProduct, cWebShop, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty ) 

   local nScan
   local hProduct

   hProduct          := {  "id"                    => idProduct,;
                           "idFirstProperty"       => idFirstProperty,;
                           "valueFirstProperty"    => valueFirstProperty,;
                           "idSecondProperty"      => idSecondProperty,;
                           "valueSecondProperty"   => valueSecondProperty,;
                           "totalStock"            => 0 }

   nScan             := hscan( ::hProductsToUpdate, {|k,v| k == cWebShop } )
   if nScan == 0
      hset( ::hProductsToUpdate, cWebShop, { hProduct } )
   else 
      if ascan( ::hProductsToUpdate[ cWebShop ], {|h| hget( h, "id" ) == idProduct .and. hget( h, "idFirstProperty" ) == idFirstProperty .and. hget( h, "valueFirstProperty" ) == valueFirstProperty .and. hget( h, "idSecondProperty" ) == idSecondProperty .and. hget( h, "valueSecondProperty" ) == valueSecondProperty } )  == 0
         aadd( ::hProductsToUpdate[ cWebShop ], hProduct )
      end if 
   end if 

Return ( ::hProductsToUpdate )   

//---------------------------------------------------------------------------//

METHOD updateWebProductStocks() 

   if !( ::TComercioConfig():isRealTimeConexion() )
      Return .f.
   end if 

   if empty(::hProductsToUpdate)
      Return .f.
   end if

   if ::filesOpen() 

      ::oWaitMeter         := TWaitMeter():New( "Actualizando stocks", "Espere por favor..." ):Run()

      ::evalProductsToStock()

      ::oWaitMeter:End()

      ::filesClose()

   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD updateProductStocks( cWebName, aProductsWeb )

   ::TComercioConfig():setCurrentWebName( cWebName )

   ::buildInformationStockProductArray( aProductsWeb )

   if ::prestaShopConnect()

      if ::TComercioConfig():isProcessWithoutStock()
         ::proccessInactivePrestashop()
      end if 
      
      ::proccessStockPrestashop()
      
      ::prestaShopDisConnect()  

   end if 

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD buildInformationStockProductArray( aProducts )

   local hProduct

   ::meterProcesoSetTotal( len( aProducts ) )

   ::resetStockProducts()

   ::resetInactiveProduct()

   for each hProduct in aProducts
      
      ::buildAddInformacionStockProductPrestashop( hProduct )
      
      ::meterProcesoText()

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD buildAddInformacionStockProductPrestashop( hProduct ) 

   local sStock
   local nTotalStock          := 0
   local aStockArticulo
   local idProduct            := hget( hProduct, "id" )
   local idFirstProperty      := hget( hProduct, "idFirstProperty" )
   local valueFirstProperty   := hget( hProduct, "valueFirstProperty" )
   local idSecondProperty     := hget( hProduct, "idSecondProperty" )
   local valueSecondProperty  := hget( hProduct, "valueSecondProperty" )

   ::writeText( 'Calculando stocks ' + alltrim( idProduct ) )

   // Recopilamos la información del Stock-------------------------------------

   aStockArticulo             := ::oStock():aStockArticulo( idProduct, ::TComercioConfig():getStore() )

   // Recorremos el array con los stocks---------------------------------------

   for each sStock in aStockArticulo

      if ( sStock:cCodigo == idProduct )                                                           .and.;
         ( empty( idFirstProperty )       .or. ( sStock:cCodigoPropiedad1 == idFirstProperty ) )   .and.;
         ( empty( valueFirstProperty )    .or. ( sStock:cValorPropiedad1 == valueFirstProperty ) ) .and.;
         ( empty( idSecondProperty )      .or. ( sStock:cCodigoPropiedad2 == idSecondProperty ) )  .and.;
         ( empty( valueSecondProperty )   .or. ( sStock:cValorPropiedad2 == valueSecondProperty ) )

         aAdd( ::aStockProducts, {  "idProduct"             => idProduct,;
                                    "idFirstProperty"       => sStock:cCodigoPropiedad1,;
                                    "idSecondProperty"      => sStock:cCodigoPropiedad2,;
                                    "valueFirstProperty"    => sStock:cValorPropiedad1,;
                                    "valueSecondProperty"   => sStock:cValorPropiedad2,;
                                    "unitStock"             => sStock:nUnidades } )

      end if  

      nTotalStock             += sStock:nUnidades 

   next

   aadd( ::aStockProducts, {  "idProduct"             => idProduct ,;
                              "idFirstProperty"       => space( 20 ) ,;
                              "idSecondProperty"      => space( 20 ) ,;
                              "valueFirstProperty"    => space( 20 ) ,;
                              "valueSecondProperty"   => space( 20 ) ,;
                              "unitStock"             => nTotalStock } )

   // Productos sin stock hay q borrarlos-------------------------------------

   if nTotalStock <= 0
      aadd( ::aInactiveProducts, idProduct )
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD proccessInactivePrestashop() 

   local idProduct

   ::meterProcesoSetTotal( len( ::aInactiveProducts ) )

   for each idProduct in ::aInactiveProducts

      ::TComercioProduct():inactivateProduct( idProduct )

      ::meterProcesoText()

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD proccessStockPrestashop() 

   local hStockProductData

   ::meterProcesoSetTotal( len( ::aStockProducts ) )

   for each hStockProductData in ::aStockProducts

      if ::setStockPrestashop( hStockProductData )
         ::saveLastInsertStock( hget( hStockProductData, "idProduct" ) )
      end if 

      ::meterProcesoText()

   next

   ::saveLastInsertStock()

Return .t.

//---------------------------------------------------------------------------//

METHOD setStockPrestashop( hStockProductData )

   local cText
   local cCommand
   local unitStock               
   local idProductPrestashop     
   local attributeFirstProperty  := 0  
   local attributeSecondProperty := 0 
   local idProductAttribute      := 0

   idProductPrestashop           := ::TPrestashopId():getValueProduct( hget( hStockProductData, "idProduct" ), ::getCurrentWebName() )

   if !empty( hget( hStockProductData, "valueFirstProperty" ) )
      attributeFirstProperty     := ::TPrestashopId():getValueAttribute( hget( hStockProductData, "idFirstProperty" ) + hget( hStockProductData, "valueFirstProperty" ), ::getCurrentWebName() )
   end if 

   if !empty( hget( hStockProductData, "valueSecondProperty" ) )
      attributeSecondProperty    := ::TPrestashopId():getValueAttribute( hget( hStockProductData, "idSecondProperty" ) + hget( hStockProductData, "valueSecondProperty" ), ::getCurrentWebName() ) 
   end if 

   unitStock                     := hget( hStockProductData, "unitStock" )

   if ( attributeFirstProperty != 0 ) .and. ( attributeSecondProperty != 0 )
      idProductAttribute         := ::idProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty ) 
   end if 

   cCommand                      := "DELETE FROM " + ::cPrefixTable( "stock_available" ) + " "                          + ;
                                       "WHERE id_product = " + alltrim( str( idProductPrestashop ) ) + " "              + ;
                                       "AND id_product_attribute = " + alltrim( str( idProductAttribute ) )

   TMSCommand():New( ::oConexionMySQLDatabase() ):ExecDirect( cCommand )

   if ( unitStock != 0 )

      cCommand                   := "INSERT INTO " + ::cPrefixTable( "stock_available" ) + " ( "                        + ;
                                       "id_product, "                                                                   + ;
                                       "id_product_attribute, "                                                         + ;
                                       "id_shop, "                                                                      + ;
                                       "id_shop_group, "                                                                + ;
                                       "quantity, "                                                                     + ;
                                       "depends_on_stock, "                                                             + ;
                                       "out_of_stock ) "                                                                + ;
                                    "VALUES ( "                                                                         + ;
                                       "'" + alltrim( str( idProductPrestashop ) ) + "', "                              + ;
                                       "'" + alltrim( str( idProductAttribute ) ) + "', "                               + ;   
                                       "'1', "                                                                          + ;
                                       "'0', "                                                                          + ;
                                       "'" + alltrim( str( unitStock ) ) + "', "                                        + ;
                                       "'0', "                                                                          + ;
                                       "'2' )"

      TMSCommand():New( ::oConexionMySQLDatabase() ):ExecDirect( cCommand )

   end if

   cText       := 'Actualizando stock con propiedades ' + alltrim( str( idProductPrestashop ) ) + ', ' 
   cText       += alltrim( str( attributeFirstProperty ) ) + ', ' 
   cText       += alltrim( str( attributeSecondProperty ) ) + ', '
   cText       += 'cantidad : ' + alltrim( str( unitStock ) )

   ::writeText( cText )

Return .t.   

//---------------------------------------------------------------------------//

METHOD idProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty )

   local oQuery
   local oQuery2
   local lPrp1                := .f.
   local lPrp2                := .f.
   local cCommand             := ""
   local idProductAttribute   := 0

   do case
      case !empty( attributeFirstProperty ) .and. empty( attributeSecondProperty )

         cCommand             := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product = " + alltrim( str( idProductPrestashop ) )

         oQuery               := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

         if oQuery:Open() .and. oQuery:recCount() > 0

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand       := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute = " + alltrim( str( oQuery:FieldGet( 1 ) ) )

               oQuery2        := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

                  if oQuery2:Open() .and. oQuery2:recCount() == 1 .and. oQuery2:FieldGet( 1 ) == attributeFirstProperty
                     idProductAttribute     := oQuery:FieldGet( 1 )
                  end if   

               oQuery:Skip()

            end while

         end if

      case !empty( attributeFirstProperty ) .and. !empty( attributeSecondProperty )

         cCommand                := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product = " + alltrim( str( idProductPrestashop ) )

         oQuery                  := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

         if oQuery:Open() // .and. oQuery:recCount() > 0

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand          := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + alltrim( str( oQuery:FieldGet( 1 ) ) )

               oQuery2           := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

                  if oQuery2:Open() .and. oQuery2:recCount() == 2

                     oQuery2:GoTop()
                     while !oQuery2:Eof()

                        if !lPrp1
                           lPrp1 := ( oQuery2:FieldGet( 1 ) == attributeFirstProperty )
                        end if

                        oQuery2:Skip()

                     end while

                     oQuery2:GoTop()
                     while !oQuery2:Eof()

                        if !lPrp2
                           lPrp2 := ( oQuery2:FieldGet( 1 ) == attributeSecondProperty )
                        end if

                        oQuery2:Skip()

                     end while

                     if lPrp1 .and. lPrp2
                        idProductAttribute     := oQuery:FieldGet( 1 )
                     end if

                  end if

               oQuery:Skip()

               lPrp1          := .f.
               lPrp2          := .f.

            end while

         end if

   end case

Return idProductAttribute

//---------------------------------------------------------------------------//

METHOD evalProductsToStock()

Return ( heval( ::hProductsToUpdate, {|cWebName, aProductsWeb| ::updateProductStocks( cWebName, aProductsWeb ) } ) )

//---------------------------------------------------------------------------//

