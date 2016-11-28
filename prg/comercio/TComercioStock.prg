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
   METHOD resetProductsToUpdateStocks()      INLINE ( ::hProductsToUpdate := {=>} )
   
   DATA  aInactiveProducts                   INIT {}
   METHOD resetInactiveProduct()             INLINE ( ::aInactiveProducts := {} )

   METHOD getProductsToUpadateStocks()       INLINE ( ::hProductsToUpdate )

   // External methods---------------------------------------------------------

   METHOD buildListProductToUpdate()

   METHOD calculateStocksProductsToUpdate()   
      METHOD calculateStocksProductToUpdate()
         METHOD addStockProductToUpdate( hProduct ) 

   METHOD setIdAttributeProductsToUpdate() 
      METHOD setIdAttributeProductToUpdate()    
         METHOD setIdAttributeProductStockToUpdate( hStockProductData )

   METHOD createCommandProductsToUpdate()
      METHOD getCommandProductToUpdate( cWebName, aProducts )

   METHOD executeCommandProductsToUpdate() 
      METHOD executeCommandProductToUpdate() 

   METHOD insertProductsToUpadateStocks() 

   METHOD updateWebProductStocks() 

   METHOD proccessInactivePrestashop()

   // Service methods----------------------------------------------------------

   METHOD resetProductsToUpdateStocks()      VIRTUAL
   METHOD getProductsToUpadateStocks()       VIRTUAL
   METHOD appendProductsToUpadateStocks()    VIRTUAL
   METHOD updateWebProductStocks( oStock )   VIRTUAL

   // Internal methods---------------------------------------------------------

   METHOD getIdAttributeProductStock( idProductPrestashop, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty )

   METHOD updateProductStocks( cWebName, aProductsWeb )

   METHOD idProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty )

   METHOD evalProductsToStock()        


   METHOD getIdProductPrestashop()

END CLASS

//---------------------------------------------------------------------------//

METHOD buildListProductToUpdate( startIdProduct )

   local idProductAttribute
   local idProductPrestashop

   ::resetProductsToUpdateStocks()

   ::resetMegaCommand()

   ::resetInactiveProduct()

   ::oProductDatabase():ordsetfocus( "lWebShop" )
   
   if ::oProductDatabase():seek( startIdProduct )

      while ( alltrim( ::oProductDatabase():cWebShop ) == ::getCurrentWebName() ) .and. !( ::oProductDatabase():eof() )

         // if alltrim( ::oProductDatabase():Codigo ) == "10003068"

         ::writeText( alltrim( ::oProductDatabase():Codigo ) + space( 1 ) + alltrim( ::oProductDatabase():Nombre ) )

         idProductPrestashop     := ::getIdProductPrestashop( ::oProductDatabase():Codigo )

         if idProductPrestashop != 0 
            ::insertProductsToUpadateStocks( ::oProductDatabase():Codigo, idProductPrestashop, ::getCurrentWebName() ) 
         end if 

         // end if 

         ::oProductDatabase():Skip()

      end while

   else 

      msgStop( ::getCurrentWebName(), 'no encontrado' )

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertProductsToUpadateStocks( idProduct, idProductPrestashop, cWebShop, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty ) 

   local nScan
   local hProduct

   hProduct          := {  "id"                    => idProduct,;
                           "idProductPrestashop"   => idProductPrestashop,;
                           "idFirstProperty"       => idFirstProperty,;
                           "valueFirstProperty"    => valueFirstProperty,;
                           "idSecondProperty"      => idSecondProperty,;
                           "valueSecondProperty"   => valueSecondProperty,;
                           "commandSQL"            => "" }

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

   ::calculateStocksProductToUpdate( aProductsWeb )

   if !( ::TComercioConfig():isProcessWithoutStock() )
      ::proccessInactivePrestashop()
   end if 
   
   ::setIdAttributeProductsToUpdate()
      
Return ( Self )   

//---------------------------------------------------------------------------//

METHOD addStockProductToUpdate( hProduct ) 
   
   local sStock
   local nTotalStock             := 0
   local aStockArticulo
   local idProductAttribute
   local aStockProducts          := {}
   local idProduct               := hget( hProduct, "id" )
   local idProductPrestashop     := hget( hProduct, "idProductPrestashop" )
   local idFirstProperty         := hget( hProduct, "idFirstProperty" )
   local valueFirstProperty      := hget( hProduct, "valueFirstProperty" )
   local idSecondProperty        := hget( hProduct, "idSecondProperty" )
   local valueSecondProperty     := hget( hProduct, "valueSecondProperty" )

   ::writeText( 'Calculando stocks ' + alltrim( idProduct ) )

   // Recopilamos la información del Stock-------------------------------------

   aStockArticulo                := ::oStock():aStockArticulo( idProduct, ::TComercioConfig():getStore() )

   // Recorremos el array con los stocks---------------------------------------

   for each sStock in aStockArticulo

      if ( sStock:cCodigo == idProduct )                                                           .and.;
         ( empty( idFirstProperty )       .or. ( sStock:cCodigoPropiedad1 == idFirstProperty ) )   .and.;
         ( empty( valueFirstProperty )    .or. ( sStock:cValorPropiedad1 == valueFirstProperty ) ) .and.;
         ( empty( idSecondProperty )      .or. ( sStock:cCodigoPropiedad2 == idSecondProperty ) )  .and.;
         ( empty( valueSecondProperty )   .or. ( sStock:cValorPropiedad2 == valueSecondProperty ) )

         idProductAttribute      := ::getIdAttributeProductStock( idProductPrestashop, sStock:cCodigoPropiedad1, sStock:cValorPropiedad1, sStock:cCodigoPropiedad2, sStock:cValorPropiedad2 )

         if sStock:nUnidades > 0

            nTotalStock          += sStock:nUnidades 

            if ( idProductAttribute != 0 ) .or. ( empty( sStock:cValorPropiedad1 ) .and. empty( sStock:cValorPropiedad2 ) )

               aadd( aStockProducts,   {  "idProduct"             => idProduct,;
                                          "idProductAttribute"    => idProductAttribute,;
                                          "idFirstProperty"       => sStock:cCodigoPropiedad1,;
                                          "idSecondProperty"      => sStock:cCodigoPropiedad2,;
                                          "valueFirstProperty"    => sStock:cValorPropiedad1,;
                                          "valueSecondProperty"   => sStock:cValorPropiedad2,;
                                          "unitStock"             => sStock:nUnidades } )

            end if 

         end if 

      end if  

   next

   // Apunte resumen necesario para prestahop----------------------------------

   idProductAttribute            := 0

   aadd( aStockProducts,         {  "idProduct"             => idProduct ,;
                                    "idProductAttribute"    => idProductAttribute,;
                                    "idFirstProperty"       => space( 20 ) ,;
                                    "idSecondProperty"      => space( 20 ) ,;
                                    "valueFirstProperty"    => space( 20 ) ,;
                                    "valueSecondProperty"   => space( 20 ) ,;
                                    "unitStock"             => nTotalStock } )

   hset( hProduct, "stocks", aStockProducts )

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

METHOD setIdAttributeProductsToUpdate() 

   local hProductsToUpdate

   ::meterProcesoSetTotal( len( ::hProductsToUpdate ) )

   if ::prestaShopConnect()

      for each hProductsToUpdate in ::hProductsToUpdate

         ::setIdAttributeProductToUpdate( hProductsToUpdate )

         ::meterProcesoText()

      next 

      ::prestaShopDisConnect()

   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD setIdAttributeProductToUpdate( hProductsToUpdate )

   aeval( hget( hProductsToUpdate, "stocks" ), {|hStock| ::setIdAttributeProductStockToUpdate( hProductsToUpdate, @hStock ) } ) 

Return .t.

//---------------------------------------------------------------------------//

METHOD setIdAttributeProductStockToUpdate( hProduct, hStock )

   local idProductAttribute      := 0
   local attributeFirstProperty  := 0  
   local attributeSecondProperty := 0 

   if !empty( hget( hStock, "valueFirstProperty" ) )
      attributeFirstProperty     := ::TPrestashopId():getValueAttribute( hget( hStock, "idFirstProperty" ) + hget( hStock, "valueFirstProperty" ), ::getCurrentWebName() )
   end if 

   if !empty( hget( hStock, "valueSecondProperty" ) )
      attributeSecondProperty    := ::TPrestashopId():getValueAttribute( hget( hStock, "idSecondProperty" ) + hget( hStock, "valueSecondProperty" ), ::getCurrentWebName() ) 
   end if 

   if ( attributeFirstProperty != 0 ) .and. ( attributeSecondProperty != 0 )
      idProductAttribute         := ::idProductAttribute( hget( hProduct, "idProductPrestashop" ), attributeFirstProperty, attributeSecondProperty ) 
   end if 

Return ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD getIdAttributeProductStock( idProductPrestashop, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty )

   local idProductAttribute      := 0
   local attributeFirstProperty  := 0  
   local attributeSecondProperty := 0

   DEFAULT idFirstProperty       := space( 20 )
   DEFAULT valueFirstProperty    := space( 20 )
   DEFAULT idSecondProperty      := space( 20 )
   DEFAULT valueSecondProperty   := space( 20 )

   if !empty( valueFirstProperty )
      attributeFirstProperty     := ::TPrestashopId():getValueAttribute( idFirstProperty + valueFirstProperty, ::getCurrentWebName() )
   end if 

   if !empty( valueSecondProperty ) 
      attributeSecondProperty    := ::TPrestashopId():getValueAttribute( idSecondProperty + valueSecondProperty, ::getCurrentWebName() ) 
   end if 

   if ( attributeFirstProperty != 0 ) .and. ( attributeSecondProperty != 0 )
      idProductAttribute         := ::idProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty ) 
   end if 

Return ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD createCommandProductsToUpdate()

   local cCommand
   local hProduct
   local aProductsToUpdate

   for each aProductsToUpdate in ::hProductsToUpdate
      
      for each hProduct in aProductsToUpdate

         cCommand    := ::getCommandProductToUpdate( hProduct )
      
         if !empty(cCommand)
            hset( hProduct, "commandSQL", cCommand )
         end if 
      
      next 

   next

Return .t.   

//---------------------------------------------------------------------------//

METHOD getCommandProductToUpdate( hProduct )

   local cText
   local hStock
   local cCommand := ""

   cCommand       += "DELETE FROM " + ::cPrefixTable( "stock_available" ) + " "                             + ;
                        "WHERE id_product = " + alltrim( str( hget( hProduct, "idProductPrestashop" ) ) )   + ";"
                     // "AND id_product_attribute = " + alltrim( str( idProductAttribute ) )

   for each hStock in hget( hProduct, "stocks" )

      if hget( hStock, "unitStock" ) > 0 

         cCommand += "INSERT INTO " + ::cPrefixTable( "stock_available" ) + " ( "                           + ;
                        "id_product, "                                                                      + ;
                        "id_product_attribute, "                                                            + ;
                        "id_shop, "                                                                         + ;
                        "id_shop_group, "                                                                   + ;
                        "quantity, "                                                                        + ;
                        "depends_on_stock, "                                                                + ;
                        "out_of_stock ) "                                                                   + ;
                     "VALUES ( "                                                                            + ;
                        "'" + alltrim( str( hget( hProduct, "idProductPrestashop" ) ) ) + "', "             + ;
                        "'" + alltrim( str( hget( hStock, "idProductAttribute" ) ) ) + "', "                + ;   
                        "'1', "                                                                             + ;
                        "'0', "                                                                             + ;
                        "'" + alltrim( str( hget( hStock, "unitStock" ) ) ) + "', "                         + ;
                        "'0', "                                                                             + ;
                        "'2' )"                                                                             + ";"

      end if

      cText       := 'Actualizando stock con propiedades '                       
      cText       += alltrim( str( hget( hProduct, "idProductPrestashop" ) ) )                              + ', ' 
      cText       += alltrim( hget( hStock, "valueFirstProperty"  ) )                                       + ', ' 
      cText       += alltrim( hget( hStock, "valueSecondProperty" ) )                                       + ', '
      cText       += 'cantidad : ' + alltrim( str( hget( hStock, "unitStock" ) ) )

      ::writeText( cText )

   next 

Return ( cCommand )   

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

METHOD calculateStocksProductsToUpdate()   

   heval( ::hProductsToUpdate, {|cWebName, aProductsWeb| ::calculateStocksProductToUpdate( cWebName, aProductsWeb ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD calculateStocksProductToUpdate( cWebName, aProducts )

   local hProduct

   ::TComercioConfig():setCurrentWebName( cWebName )

   ::meterProcesoSetTotal( len( aProducts ) )
      
   if ::prestaShopConnect()

      for each hProduct in aProducts
         
         ::addStockProductToUpdate( hProduct )
            
         ::meterProcesoText()

      next

      ::prestaShopDisConnect()

   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD evalProductsToStock()

   if ::prestaShopConnect()

      heval( ::hProductsToUpdate, {|cWebName, aProductsWeb| ::updateProductStocks( cWebName, aProductsWeb ) } ) 

      ::prestaShopDisConnect()

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD executeCommandProductsToUpdate()

   heval( ::hProductsToUpdate, {|cWebName, aProductsWeb| ::executeCommandProductToUpdate( cWebName, aProductsWeb ) } ) 

Return .t.   

//---------------------------------------------------------------------------//

METHOD executeCommandProductToUpdate( cWebName, aProducts )

   local hProduct
   local cCommand

   ::TComercioConfig():setCurrentWebName( cWebName )

   ::meterProcesoSetTotal( len( aProducts ) )
      
   if ::prestaShopConnect()

      for each hProduct in aProducts
         
         cCommand    := hget( hProduct, "commandSQL" )

         if !empty( cCommand )
            ::commandExecDirect( cCommand )
         end if 
            
         ::meterProcesoText()

      next

      ::prestaShopDisConnect()

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getIdProductPrestashop( idProductGestool )

   local idProductPrestashop     := ::TPrestashopId():getValueProduct( idProductGestool, ::getCurrentWebName() )

   if ( idProductPrestashop == 0 )
      ::writeText( "Producto " + alltrim( idProductGestool ) + " no encontrado en la web " + alltrim( ::getCurrentWebName() ) )
   end if

Return ( idProductPrestashop)

//---------------------------------------------------------------------------//

