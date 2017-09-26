#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioStock FROM TComercioConector

   DATA  TComercio

   DATA  oWaitMeter

   DATA  externalsProductsToUpdate           INIT {}
   DATA  hProductsToUpdate                   INIT {=>}

   METHOD resetProductsToUpdateStocks()      INLINE ( ::hProductsToUpdate := {=>} )
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
      METHOD createCommandProductToUpdate()
         METHOD getCommandProductToUpdate()

   METHOD insertProductsToUpadateStocks() 

   // Service methods----------------------------------------------------------

   METHOD appendProductsToUpadateStocks()    

   METHOD updateWebProductStocks() 

   // Internal methods---------------------------------------------------------

   METHOD getIdAttributeProductStock( idProductPrestashop, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty )

   METHOD updateProductStocks( cWebName, aProductsWeb )

   METHOD idProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty )

   METHOD evalProductsToStock()        

   METHOD getIdProductPrestashop()

   METHOD executeMultiCommand(cMultiCommand)

END CLASS

//---------------------------------------------------------------------------//

METHOD buildListProductToUpdate( startIdProduct )

   local idProductAttribute
   local idProductPrestashop

   ::resetProductsToUpdateStocks()

   ( D():Articulos( ::getView() ) )->( ordsetfocus( "lWebShop" ) )
   
   if ( D():Articulos( ::getView() ) )->( dbseek( startIdProduct ) )

      while ( alltrim( ( D():Articulos( ::getView() ) )->cWebShop ) == ::getCurrentWebName() ) .and. !( ( D():Articulos( ::getView() ) )->( eof() ) )

         ::writeText( alltrim( ( D():Articulos( ::getView() ) )->Codigo ) + space( 1 ) + alltrim( ( D():Articulos( ::getView() ) )->Nombre ) )

         idProductPrestashop     := ::getIdProductPrestashop( ( D():Articulos( ::getView() ) )->Codigo, ::getCurrentWebName() )

         if idProductPrestashop != 0 
            ::insertProductsToUpadateStocks( ( D():Articulos( ::getView() ) )->Codigo, idProductPrestashop, ::getCurrentWebName() )
         end if 

         ( D():Articulos( ::getView() ) )->( dbskip() )

      end while

   else 

      msgStop( ::getCurrentWebName(), 'no encontrado' )

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD appendProductsToUpadateStocks( idProduct, nView )

   local nScan
   local cWebShop
   local idProductPrestashop

   if Empty( nView )
      Return ( self )
   end if

   if D():gotoArticulos( idProduct, nView )
      cWebShop                := ( D():Articulos( nView ) )->cWebShop
   end if 

   if empty(cWebShop)
      Return ( self )
   end if

   idProductPrestashop        := ::getIdProductPrestashop( idProduct, cWebShop )

   if empty(idProductPrestashop)
      Return ( self )
   end if

   ::insertProductsToUpadateStocks( idProduct, idProductPrestashop, cWebShop ) 

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

   ::oWaitMeter      := TWaitMeter():New( "Actualizando stocks", "Espere por favor..." ):Run()

   ::calculateStocksProductsToUpdate()

   ::createCommandProductsToUpdate()

   ::oWaitMeter:End()

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD updateProductStocks( cWebName, aProductsWeb )

   ::TComercioConfig():setCurrentWebName( cWebName )

   ::calculateStocksProductToUpdate( aProductsWeb )
 
   ::setIdAttributeProductsToUpdate()
      
Return ( Self )   

//---------------------------------------------------------------------------//

METHOD addStockProductToUpdate( hProduct ) 
   
   local sStock
   local nTotalStock             := 0
   local aStockArticulo
   local idProductAttribute      := 0
   local aStockProducts          := {}
   local idProduct               := hget( hProduct, "id" )
   local idProductPrestashop     := hget( hProduct, "idProductPrestashop" )
   local idFirstProperty         := hget( hProduct, "idFirstProperty" )
   local valueFirstProperty      := hget( hProduct, "valueFirstProperty" )
   local idSecondProperty        := hget( hProduct, "idSecondProperty" )
   local valueSecondProperty     := hget( hProduct, "valueSecondProperty" )

   if !empty(::oWaitMeter)
      ::oWaitMeter:setMessage( 'Calculando stocks ' + alltrim( idProduct ) )
   end if 

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

         // if sStock:nUnidades > 0

            nTotalStock          += sStock:nUnidades 

            if ( !empty( sStock:cValorPropiedad1 ) .or. !empty( sStock:cValorPropiedad2 ) )

               aadd( aStockProducts,   {  "idProduct"             => idProduct,;
                                          "idProductAttribute"    => idProductAttribute,;
                                          "idFirstProperty"       => sStock:cCodigoPropiedad1,;
                                          "idSecondProperty"      => sStock:cCodigoPropiedad2,;
                                          "valueFirstProperty"    => sStock:cValorPropiedad1,;
                                          "valueSecondProperty"   => sStock:cValorPropiedad2,;
                                          "unitStock"             => sStock:nUnidades } )

            end if 

         // end if 

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

Return .t.

//---------------------------------------------------------------------------//

METHOD setIdAttributeProductsToUpdate() 

   local hProductsToUpdate

   ::meterProcesoSetTotal( len( ::hProductsToUpdate ) )

   for each hProductsToUpdate in ::hProductsToUpdate

      ::setIdAttributeProductToUpdate( hProductsToUpdate )

      ::meterProcesoText()

   next 

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

   if ( attributeFirstProperty != 0 ) .or. ( attributeSecondProperty != 0 )
      idProductAttribute         := ::idProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty ) 
   end if 

Return ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD createCommandProductsToUpdate()

   heval( ::hProductsToUpdate, {|cWebName, aProductsWeb| ::createCommandProductToUpdate( cWebName, aProductsWeb ) } )

Return .t.   

//---------------------------------------------------------------------------//

METHOD createCommandProductToUpdate( cWebName, aProductsToUpdate )

   local cCommand
   local hProduct

   ::TComercioConfig():setCurrentWebName( cWebName )

   ::meterProcesoSetTotal( len( ::hProductsToUpdate ) )
      
    if ::prestaShopConnect()

      for each hProduct in aProductsToUpdate

         if !empty( hProduct )

            cCommand    := ::getCommandProductToUpdate( hProduct )
         
            if !empty(cCommand)
               ::executeMultiCommand( cCommand )
            end if 

            ::TComercio:saveLastInsertStock( hget( hProduct, "id" ) )   

         end if 
         
      next

      ::prestaShopDisConnect()

      Return .t.

   end if 

Return .t.   

//---------------------------------------------------------------------------//

METHOD getCommandProductToUpdate( hProduct )

   local cText
   local aStock
   local hStock
   local cCommand             := ""
   local nTotalStock          := 0
   local idProductAttribute   := 0

   if !( hhaskey( hProduct, "stocks" ) )
      Return ( cCommand )
   end if 

   aStock                     := hget( hProduct, "stocks" )

   cCommand                   += "DELETE FROM " + ::cPrefixTable( "stock_available" )                                   + ;
                                 " WHERE id_product = " + alltrim( str( hget( hProduct, "idProductPrestashop" ) ) )     + ";"

   for each hStock in aStock

      idProductAttribute      := ::TPrestashopId():getValueProductAttributeCombination( hget( hProduct, "id" ) + hget( hStock, "idFirstProperty" ) + hget( hStock, "valueFirstProperty" ) + hget( hStock, "idSecondProperty" ) + hget( hStock, "valueSecondProperty" ), ::getCurrentWebName() )

      if ( .t. ) // ( idProductAttribute != 0 ) .and. ( hget( hStock, "unitStock" ) > 0 )

         cCommand             += "INSERT IGNORE INTO " + ::cPrefixTable( "stock_available" ) + " ( "                    + ;
                                    "id_product, "                                                                      + ;
                                    "id_product_attribute, "                                                            + ;
                                    "id_shop, "                                                                         + ;
                                    "id_shop_group, "                                                                   + ;
                                    "quantity, "                                                                        + ;
                                    "depends_on_stock, "                                                                + ;
                                    "out_of_stock ) "                                                                   + ;
                                 "VALUES ( "                                                                            + ;
                                    "'" + alltrim( str( hget( hProduct, "idProductPrestashop" ) ) ) + "', "             + ;
                                    "'" + alltrim( str( idProductAttribute ) ) + "', "                                  + ;   
                                    "'1', "                                                                             + ;
                                    "'0', "                                                                             + ;
                                    "'" + alltrim( str( hget( hStock, "unitStock" ) ) ) + "', "                         + ;
                                    "'0', "                                                                             + ;
                                    "'2' )"                                                                             + ";"

         nTotalStock          += hget( hStock, "unitStock" )       

      end if

      cText                   := 'Actualizando stock, propiedades ' 
      cText                   += alltrim( hget( hProduct, "id" ) )                                                      + ', ' 
      cText                   += alltrim( str( hget( hProduct, "idProductPrestashop" ) ) )                              + ', ' 
      cText                   += alltrim( hget( hStock, "valueFirstProperty"  ) )                                       + ', ' 
      cText                   += alltrim( hget( hStock, "valueSecondProperty" ) )                                       + ', '
      cText                   += 'cantidad : ' + alltrim( str( hget( hStock, "unitStock" ) ) )


   next 

   if ( nTotalStock <= 0 ) .and. ( TComercioConfig():isDeleteWithoutStock() )

      cCommand                := "UPDATE  " + ::cPrefixTable( "product" )                                               + ;
                                 " SET active = 0, indexed = 0"                                                         + ;
                                 " WHERE id_product = '" + alltrim( str( hget( hProduct, "idProductPrestashop" ) ) )    + "';"

      cText                   := 'Desactivando artículo ' 
      cText                   += alltrim( hget( hProduct, "id" ) )                                                      + ', ' 
      cText                   += alltrim( str( hget( hProduct, "idProductPrestashop" ) ) )                              + ', ' 

   end if 

   if !empty(::oWaitMeter)
      ::oWaitMeter:setMessage( cText )
   end if 

   ::writeText( cText )

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

         ::writeText( cCommand )

         oQuery               := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

         if oQuery:Open() .and. oQuery:recCount() > 0

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand       := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute = " + alltrim( str( oQuery:FieldGet( 1 ) ) )

               ::writeText( cCommand )

               oQuery2        := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

               if oQuery2:Open() .and. oQuery2:recCount() == 1 .and. oQuery2:fieldGet( 1 ) == attributeFirstProperty
                  idProductAttribute     := oQuery:fieldGet( 1 )
                  exit
               end if   

               oQuery:Skip()

            end while

         end if

      case !empty( attributeFirstProperty ) .and. !empty( attributeSecondProperty )

         cCommand             := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product = " + alltrim( str( idProductPrestashop ) )

         ::writeText( cCommand )

         oQuery               := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

         if oQuery:Open()

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand       := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + alltrim( str( oQuery:FieldGet( 1 ) ) )

               ::writeText( cCommand )

               oQuery2        := TMSQuery():New( ::oConexionMySQLDatabase(), cCommand )

               if oQuery2:Open() .and. oQuery2:recCount() == 2

                  oQuery2:GoTop()
                  while !oQuery2:Eof()

                     if !lPrp1
                        lPrp1 := ( oQuery2:FieldGet( 1 ) == attributeFirstProperty )
                        exit
                     end if

                     oQuery2:Skip()

                  end while

                  oQuery2:GoTop()
                  while !oQuery2:Eof()

                     if !lPrp2
                        lPrp2 := ( oQuery2:FieldGet( 1 ) == attributeSecondProperty )
                        exit
                     end if

                     oQuery2:Skip()

                  end while

                  if lPrp1 .and. lPrp2
                     idProductAttribute     := oQuery:FieldGet( 1 )
                     exit
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

   ::meterProcesoSetTotal( len( aProducts ) )
      
   for each hProduct in aProducts
      
      ::addStockProductToUpdate( hProduct )
         
      ::meterProcesoText()

   next

Return .f.

//---------------------------------------------------------------------------//

METHOD evalProductsToStock()

   if ::prestaShopConnect()

      heval( ::hProductsToUpdate, {|cWebName, aProductsWeb| ::updateProductStocks( cWebName, aProductsWeb ) } ) 

      ::prestaShopDisConnect()

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getIdProductPrestashop( idProductGestool, cCurrentWebName )

   local idProductPrestashop     := ::TPrestashopId():getValueProduct( idProductGestool, cCurrentWebName )

   if ( idProductPrestashop == 0 )
      ::writeText( "Producto " + alltrim( idProductGestool ) + " no encontrado en la web " + alltrim( cCurrentWebName ) )
   end if

Return ( idProductPrestashop)

//---------------------------------------------------------------------------//

METHOD executeMultiCommand(cMultiCommand)

   local cCommand
   local aCommand := hb_atokens( cMultiCommand, ";")

   for each cCommand in aCommand

      if !empty( cCommand )
         ::commandExecDirect( cCommand )
      end if 
      
   next 

Return ( self )

//---------------------------------------------------------------------------//
