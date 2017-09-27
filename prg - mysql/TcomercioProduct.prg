#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define __tipoProducto__      1
#define __tipoCategoria__     2     

//---------------------------------------------------------------------------//

CLASS TComercioProduct FROM TComercioConector

   DATA  TComercio

   DATA  aProducts                                          INIT {}
   DATA  aTaxProducts                                       INIT {}
   DATA  aManufacturersProduct                              INIT {}
   DATA  aPropertiesHeaderProduct                           INIT {}
   DATA  aPropertiesLineProduct                             INIT {}

   DATA  idCategoryDefault  
   DATA  idTaxRulesGroup 
   DATA  idManufacturer    

   METHOD isProductInDatabase( idProduct )                         
   METHOD isProductInCurrentWeb()                           

   METHOD buildAllProductInformation()
   METHOD buildProductInformation( idProduct )
      METHOD buildIvaProducts( id )  
      METHOD buildManufacturerProduct( id )
      METHOD buildPropertyProduct( id )
      METHOD buildProduct( id )

      METHOD getPrice()
      METHOD getPriceReduction()
      METHOD getPriceReductionTax()                         INLINE ( iif(  ::oProductDatabase():lIvaWeb, 1, 0 ) )
      METHOD getDescription()                               INLINE ( iif(  !empty( ::oProductDatabase():mDestec ),;
                                                                           alltrim( ::oProductDatabase():mDestec ),;
                                                                           alltrim( ::oProductDatabase():Nombre ) ) )

      METHOD imagesProduct( id )
      METHOD stockProduct( id )

   METHOD insertNodeProductCategory()

   METHOD insertProducts()
      METHOD insertProduct()
         METHOD insertProductPrestashopTable( hProduct )
         
         METHOD insertProductShop( idProduct, idCategory )
         METHOD insertProductLang( idProduct, idCategory )

         METHOD processImageProducts( idProduct, hProduct )
            METHOD insertImage( idProduct, hProduct, hImage, nImagePosition )
               METHOD insertImageLang( hProduct, hImage, idImagePrestashop )
               METHOD insertImageShop( idProduct, hProduct, hImage, idImagePrestashop )

      METHOD processPropertyProduct( idProduct, hProduct )
         METHOD insertProductAttributePrestashop( idProduct, hProduct, priceProperty )
         METHOD insertProductAttributeCombination( idFirstProperty, valueFirstProperty, idProperty )
         METHOD insertProductAttributeShop( lDefault, idProduct, idProperty, priceProperty )
         METHOD insertProductAttributeImage( hProduct, idProductAttribute )

      METHOD insertPropertiesHeader( hPropertiesHeaderProduct ) 
      METHOD insertPropertiesLineProduct( hPropertiesLineProduct )

   METHOD insertProductCategory( idProduct, idCategory )

   METHOD insertAditionalInformation()

   METHOD truncateAllTables() 

   METHOD insertTaxPrestashop( hTax )
   METHOD insertManufacturersPrestashop( hFabricantesData )

   METHOD deleteProduct( hProduct )
   METHOD deleteImages( idProductPrestashop )

   METHOD cleanGestoolReferences()

   METHOD uploadImagesToPrestashop()
      METHOD uploadImageToPrestashop( hProduct )
         METHOD buildFilesProductImages( hProductImage )
         METHOD ftpUploadFilesProductImages( hProductImage )

   METHOD getTotalStock( hProduct ) 
   METHOD isTotalStockZero( hProduct )                         INLINE ( ::getTotalStock( hProduct ) == 0 )

   METHOD insertReduction( hProduct, idProduct )

   METHOD processStockProduct( hProduct, idProduct )
      METHOD insertStockProduct( hStock ) 

   METHOD getProductAttribute( idProductPrestashop, cCodWebValPr1, cCodWebValPr2 )

END CLASS

//---------------------------------------------------------------------------//

METHOD buildAllProductInformation() CLASS TComercioProduct

   ::writeText( "Procesando articulos ... " )

   ::oProductDatabase():ordsetfocus( "lWebShop" )

   if ::oProductDatabase():seek( ::getCurrentWebName() )

      while ( alltrim( ::oProductDatabase():cWebShop ) == ::getCurrentWebName() ) .and. !( ::oProductDatabase():eof() )

         ::buildProductInformation( ::oProductDatabase():Codigo )

         ::oProductDatabase():Skip()

      end while

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildProductInformation( idProduct ) CLASS TComercioProduct

   if !( ::isProductInDatabase( idProduct ) )
      Return .f.
   end if 

   if !( ::isProductInCurrentWeb( idProduct ) )
      Return ( .f. )
   end if 

   // ::writeText( alltrim( ::oProductDatabase():Codigo ) + " - " + alltrim( ::oProductDatabase():Nombre ) )

   ::buildIvaProducts( ::oProductDatabase():TipoIva )

   ::buildManufacturerProduct( ::oProductDatabase():cCodFab )

   ::TComercioCategory():buildCategory( ::oProductDatabase():Familia )
   
   ::buildPropertyProduct( ::oProductDatabase():Codigo )
      
Return ( .t. )

//---------------------------------------------------------------------------//

METHOD isProductInDatabase( idProduct ) CLASS TComercioProduct

   if !( ::oProductDatabase():seekInOrd( idProduct, "Codigo" ) )
      ::writeText( "El artículo " + alltrim( idProduct  ) + " no se ha encontrado en la base de datos" )
      Return ( .f. )
   end if 

Return ( .t. )
                                                                           
//---------------------------------------------------------------------------//

METHOD isProductInCurrentWeb( idProduct ) CLASS TComercioProduct

   if !( ::oProductDatabase():lPubInt )
      ::writeText( "Artículo " + alltrim( idProduct ) + " no seleccionado para web" ) 
      Return .f.
   end if 

   if ( alltrim( ::oProductDatabase():cWebShop ) != ::getCurrentWebName() ) 
      ::writeText( "Artículo " + alltrim( idProduct ) + " no pertence a la web seleccionada" )
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD buildIvaProducts( id ) CLASS TComercioProduct

   if !( ::isSyncronizeAll() )
      Return .f. 
   end if 

   if aScan( ::aTaxProducts, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f. 
   end if 
   
   if ::TPrestashopId():getValueTax( id, ::getCurrentWebName() ) == 0
      if ::oIvaDatabase():seekInOrd( id, "Tipo" )
         aadd( ::aTaxProducts,   {  "id"     => id,;
                                    "rate"   => alltrim( str( ::oIvaDatabase():TpIva ) ),;
                                    "name"   => alltrim( ::oIvaDatabase():DescIva ) } )
      end if 
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildManufacturerProduct( id ) CLASS TComercioProduct

   if !( ::isSyncronizeAll() )
      Return .f. 
   end if 

   if aScan( ::aManufacturersProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if 

   if ::TPrestashopId():getValueManufacturer( id, ::getCurrentWebName() ) == 0
      if ::oManufacturerDatabase():SeekInOrd( id, "cCodFab" ) .and. ::oManufacturerDatabase():lPubInt
         aadd( ::aManufacturersProduct,   {  "id"     => id,;
                                             "name"   => rtrim( ::oManufacturerDatabase():cNomFab ) } )
      end if
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildPropertyProduct( id ) CLASS TComercioProduct

   /*
   Primera propiedad--------------------------------------------------------
   */

   if ::oPropertyDatabase():SeekInOrd( ::oProductDatabase():cCodPrp1 ) 

      if aScan( ::aPropertiesHeaderProduct, {|h| hGet( h, "id" ) == ::oPropertyDatabase():cCodPro } ) == 0

         if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

            aAdd( ::aPropertiesHeaderProduct,   {  "id"     => ::oPropertyDatabase():cCodPro,;
                                                   "name"   => if( empty( ::oPropertyDatabase():cNomInt ), alltrim( ::oPropertyDatabase():cDesPro ), alltrim( ::oPropertyDatabase():cNomInt ) ),;
                                                   "lColor" => ::oPropertyDatabase():lColor } )

         end if

      end if 

   end if

   /*
   Segunda propiedad--------------------------------------------------------
   */

   if ::oPropertyDatabase():SeekInOrd( ::oProductDatabase():cCodPrp2 ) 
      
      if aScan( ::aPropertiesHeaderProduct, {|h| hGet( h, "id" ) == ::oPropertyDatabase():cCodPro } ) == 0

         if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

            aAdd( ::aPropertiesHeaderProduct,   {  "id"     => ::oPropertyDatabase():cCodPro,;
                                                   "name"   => if( empty( ::oPropertyDatabase():cNomInt ), alltrim( ::oPropertyDatabase():cDesPro ), alltrim( ::oPropertyDatabase():cNomInt ) ),;
                                                   "lColor" => ::oPropertyDatabase():lColor } )

         end if
         
      end if

   end if

   /*
   Líneas de propiedades de un artículo-------------------------------------
   */

   if ::oPropertyProductDatabase():Seek( ::oProductDatabase():Codigo )

      while ::oPropertyProductDatabase():cCodArt == ::oProductDatabase():Codigo .and. !::oPropertyProductDatabase():Eof()

         if ::oPropertiesLinesDatabase():SeekInOrd( ::oPropertyProductDatabase():cCodPr1 + ::oPropertyProductDatabase():cValPr1, "cCodPro" )

            if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttribute( ::oPropertiesLinesDatabase():cCodPro + ::oPropertiesLinesDatabase():cCodTbl, ::getCurrentWebName() ) == 0

               if aScan( ::aPropertiesLineProduct, {|h| hGet( h, "id" ) == ::oPropertiesLinesDatabase():cCodTbl .and. hGet( h, "idparent" ) == ::oPropertiesLinesDatabase():cCodPro } ) == 0
      
                  aAdd( ::aPropertiesLineProduct,  {  "id"           => ::oPropertiesLinesDatabase():cCodTbl,;
                                                      "idparent"     => ::oPropertiesLinesDatabase():cCodPro,; 
                                                      "name"         => alltrim( ::oPropertiesLinesDatabase():cDesTbl ),;
                                                      "color"        => alltrim( RgbToRgbHex( ::oPropertiesLinesDatabase():nColor ) ),;
                                                      "position"     => ::oPropertiesLinesDatabase():nOrdTbl } )

               end if

            end if

         end if

         if ::oPropertiesLinesDatabase():SeekInOrd( ::oPropertyProductDatabase():cCodPr2 + ::oPropertyProductDatabase():cValPr2, "cCodPro" )

            if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttribute( ::oPropertiesLinesDatabase():cCodPro + ::oPropertiesLinesDatabase():cCodTbl, ::getCurrentWebName() ) == 0

               if aScan( ::aPropertiesLineProduct, {|h| hGet( h, "id" ) == ::oPropertiesLinesDatabase():cCodTbl .and. hGet( h, "idparent" ) == ::oPropertiesLinesDatabase():cCodPro } ) == 0
      
                  aAdd( ::aPropertiesLineProduct,  {  "id"           => ::oPropertiesLinesDatabase():cCodTbl,;
                                                      "idparent"     => ::oPropertiesLinesDatabase():cCodPro,; 
                                                      "name"         => alltrim( ::oPropertiesLinesDatabase():cDesTbl ),;
                                                      "color"        => alltrim( RgbToRgbHex( ::oPropertiesLinesDatabase():nColor ) ),;
                                                      "position"     => ::oPropertiesLinesDatabase():nOrdTbl } )

               end if

            end if

         end if

         ::oPropertyProductDatabase():Skip()

      end while

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildProduct( idProduct, lCleanProducts ) CLASS TComercioProduct

   local aStockArticulo       := {}
   local aImagesArticulos     := {}

   DEFAULT lCleanProducts     := .f.

   if lCleanProducts
      ::aProducts             := {}
   else
      if aScan( ::aProducts, {|h| hGet( h, "id" ) == idProduct } ) != 0
         Return ( .f. )
      end if 
   end if 

   if !( ::isProductInDatabase( idProduct ) )
      Return ( .f. )
   end if 

   if !( ::isProductInCurrentWeb( idProduct ) )
      Return ( .f. )
   end if 

   // Recopilar info del stock-------------------------------------------------

   aStockArticulo             := ::stockProduct( idProduct )

   if !( ::TPrestashopConfig():isProcessWithoutStock() ) .and. ::isTotalStockZero( aStockArticulo )
      ::writeText( "El artículo " + alltrim( idProduct ) + " no tiene stock en el almacen de la web")
      Return ( .f. )
   end if 

   // Recopilar info de imagenes-----------------------------------------

   aImagesArticulos           := ::imagesProduct( idProduct )
   if empty( aImagesArticulos )
      ::writeText( "El artículo " + alltrim( idProduct ) + " no tiene imagenes")
      Return ( .f. )
   end if 

   // Rellenamos el Hash-------------------------------------------------

   aAdd( ::aProducts,   {  "id"                    => idProduct,;
                           "name"                  => alltrim( ::oProductDatabase():Nombre ),;
                           "id_manufacturer"       => ::oProductDatabase():cCodFab ,;
                           "id_tax_rules_group"    => ::oProductDatabase():TipoIva ,;
                           "id_category_default"   => ::oProductDatabase():Familia ,;
                           "reference"             => ::oProductDatabase():Codigo ,;
                           "weight"                => ::oProductDatabase():nPesoKg ,;
                           "specific_price"        => ::oProductDatabase():lSbrInt,;
                           "description_short"     => alltrim( ::oProductDatabase():Nombre ) ,;
                           "link_rewrite"          => cLinkRewrite( ::oProductDatabase():Nombre ),;
                           "meta_title"            => alltrim( ::oProductDatabase():cTitSeo ) ,;
                           "meta_description"      => alltrim( ::oProductDatabase():cDesSeo ) ,;
                           "meta_keywords"         => alltrim( ::oProductDatabase():cKeySeo ) ,;
                           "lPublicRoot"           => ::oProductDatabase():lPubPor,;
                           "cImagen"               => alltrim( ::oProductDatabase():cImagen ),;
                           "price"                 => ::getPrice(),;
                           "reduction"             => ::getPriceReduction(),;
                           "reduction_tax"         => ::getPriceReductionTax(),;
                           "description"           => ::getDescription(),; 
                           "aImages"               => aImagesArticulos,;
                           "aStock"                => aStockArticulo } )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD getPrice() CLASS TComercioProduct

   local priceProduct      := 0

   // calcula el precio en funcion del descuento-------------------------------

   if ::oProductDatabase():lSbrInt .and. ::oProductDatabase():pVtaWeb != 0

      priceProduct         := ::oProductDatabase():pVtaWeb

   else

      if ::oProductDatabase():lIvaWeb
         priceProduct      := round( ::oProductDatabase():nImpIva1 / ( ( nIva( ::oIvaDatabase():cAlias, ::oProductDatabase():TipoIva ) / 100 ) + 1 ), 6 )
      else
         priceProduct      := ::oProductDatabase():nImpInt1
      end if

   end if 

Return ( priceProduct )

//---------------------------------------------------------------------------//
//
// calcula la reduccion sobre el precio
//

METHOD getPriceReduction() CLASS TComercioProduct

   local priceReduction    := 0

   if ::oProductDatabase():lSbrInt .and. ::oProductDatabase():pVtaWeb != 0

      if ::oProductDatabase():lIvaWeb
         priceReduction    := ::oProductDatabase():pVtaWeb
         priceReduction    += ::oProductDatabase():pVtaWeb * nIva( ::oIvaDatabase():cAlias, ::oProductDatabase():TipoIva ) / 100
         priceReduction    -= ::oProductDatabase():nImpIva1 
      else
         priceReduction    := ::oProductDatabase():pVtaWeb 
         priceReduction    -= ::oProductDatabase():nImpInt1
      end if

   end if 

Return ( priceReduction )

//---------------------------------------------------------------------------//

METHOD imagesProduct( id ) CLASS TComercioProduct

   local cImagen
   local aImages        := {}
   local cImgToken      := ""
   local aImgToken      := {}
   local nOrdAntImg
   local nOrdAntDiv     

   // Pasamos las imágenes de los artículos por propiedades-----------------------

   nOrdAntDiv           := ::oPropertyProductDatabase():OrdSetFocus( "cCodigo" )
   if ::oPropertyProductDatabase():Seek( id )

      while ::oPropertyProductDatabase():cCodArt == id .and. !::oPropertyProductDatabase():Eof()

         if !empty( ::oPropertyProductDatabase():mImgWeb )

            aImgToken   := hb_atokens( ::oPropertyProductDatabase():mImgWeb, "," )

            for each cImgToken in aImgToken

               if file( cImgToken ) .and. ascan( aImages, {|a| hGet( a, "name" ) == cImgToken } ) == 0
                  aadd( aImages, {  "name"      => cImgToken,;
                                    "id"        => oRetFld( cImgToken, ::oImageProductDatabase(), "nId", "cImgArt" ),;
                                    "lDefault"  => oRetFld( cImgToken, ::oImageProductDatabase(), "lDefImg", "cImgArt" ) } )
               end if 

            next

         end if

         ::oPropertyProductDatabase():Skip()

      end while

   end if

   ::oPropertyProductDatabase():OrdSetFocus( nOrdAntDiv )

   // Pasamos las imágenes de la tabla de artículos-------------------------------

   if empty( aImages )

      nOrdAntImg     := ::oImageProductDatabase():OrdSetFocus( "cCodArt" )
      if ::oImageProductDatabase():Seek( id )

         while ::oImageProductDatabase():cCodArt == id .and. !::oImageProductDatabase():Eof()

            cImagen  := alltrim( ::oImageProductDatabase():cImgArt )

            if file( cImagen ) .and. ascan( aImages, {|a| hGet( a, "name" ) == cImagen } ) == 0
               aadd( aImages, {  "name"      => cImagen,;
                                 "id"        => ::oImageProductDatabase():nId,;
                                 "lDefault"  => ::oImageProductDatabase():lDefImg } )
            end if 

            ::oImageProductDatabase():Skip()

         end while

      end if 

      ::oImageProductDatabase():OrdSetFocus( nOrdAntImg )

   end if

   // Nos aseguramos de que por lo menos una imágen sea por defecto------------

   if !empty( aImages ) .and. ascan( aImages, {|a| hGet( a, "lDefault" ) == .t. } ) == 0
      hSet( aImages[ 1 ], "lDefault", .t. )
   end if   

Return ( aImages )

//---------------------------------------------------------------------------//

METHOD stockProduct( id ) CLASS TComercioProduct
   
   local sStock
   local nStock            := 0
   local aStockProduct     := {}
   local aStockArticulo    := ::oStock():aStockArticulo( id, ::TPrestashopConfig():getStore() )

   for each sStock in aStockArticulo

      aAdd( aStockProduct, {  "idProduct"             => id ,;
                              "idFirstProperty"       => sStock:cCodigoPropiedad1 ,;
                              "idSecondProperty"      => sStock:cCodigoPropiedad2 ,;
                              "valueFirstProperty"    => sStock:cValorPropiedad1 ,;
                              "valueSecondProperty"   => sStock:cValorPropiedad2 ,;
                              "unitStock"             => sStock:nUnidades } )

      nStock               += sStock:nUnidades

   next

   // apunte resumen ---------------------------------------------------------

   aAdd( aStockProduct, {  "idProduct"             => id ,;
                           "idFirstProperty"       => space( 20 ) ,;
                           "idSecondProperty"      => space( 20 ) ,;
                           "valueFirstProperty"    => space( 20 ) ,;
                           "valueSecondProperty"   => space( 20 ) ,;
                           "unitStock"             => nStock } )

Return ( aStockProduct )

//---------------------------------------------------------------------------//

METHOD truncateAllTables() CLASS TComercioProduct

   local tableToDelete
   local tablesToDelete := {  "tax",;
                              "tax_lang",;
                              "tax_rule",;
                              "tax_rules_group",;
                              "tax_rules_group_shop",;
                              "manufacturer",;
                              "manufacturer_shop",;
                              "manufacturer_lang",;
                              "image",;
                              "image_shop",;
                              "image_lang" ,;
                              "attribute",;
                              "attribute_lang",;
                              "attribute_shop",;
                              "attribute_impact",;
                              "attribute_group",;
                              "attribute_group_lang",;
                              "product",;
                              "product_attachment",;
                              "product_attribute",;
                              "product_attribute_combination",;
                              "product_attribute_shop",;
                              "product_attribute_image",;
                              "product_country_tax",;
                              "product_download",;
                              "product_group_reduction_cache",;
                              "product_shop",;
                              "product_lang",;
                              "product_sale",;
                              "product_tag",;
                              "specific_price",;
                              "feature",;
                              "feature_lang",;
                              "feature_product",;
                              "feature_value",;
                              "feature_value_lang",;
                              "scene",;
                              "scene_category",;
                              "scene_lang",;
                              "scene_products",;
                              "stock_available" }

   for each tableToDelete in tablesToDelete
      ::truncateTable( tableToDelete )
   next 

Return ( self )

//---------------------------------------------------------------------------//

METHOD cleanGestoolReferences() CLASS TComercioProduct

   ::writeText( "Limpiamos las referencias de las tablas de tipos de impuestos" )

   ::TPrestashopId():deleteDocumentValuesTax( ::getCurrentWebName() )
   ::TPrestashopId():deleteDocumentValuesTaxRuleGroup( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de fabricantes" )

   ::TPrestashopId():deleteDocumentValuesManufacturer( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de propiedades" )

   ::TPrestashopId():deleteDocumentValuesAttribute( ::getCurrentWebName() )
   ::TPrestashopId():deleteDocumentValuesAttributeGroup( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de artículos" )

   ::TPrestashopId():deleteDocumentValuesProduct( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las imagenes" )

   ::TPrestashopId():deleteDocumentValuesImage( ::getCurrentWebName() )

Return ( Self )

//---------------------------------------------------------------------------//
// Subimos los artículos----------------------------------------------------

METHOD insertProducts() CLASS TComercioProduct

   local hProduct
   local nProducts   := len( ::aProducts )

   ::meterProcesoSetTotal( nProducts )
   
   for each hProduct in ::aProducts

      ::meterProcesoText( "Eliminando artículo anterior " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) ) 

      ::deleteProduct( hProduct )

      ::meterProcesoText( "Subiendo artículo " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) ) 

      ::insertProduct( hProduct )
   
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertProduct( hProduct ) CLASS TComercioProduct

   local idProduct
   local idCategory

   idCategory           := hGet( hProduct, "id_category_default" )

   ::idCategoryDefault  := ::TPrestashopId():getValueCategory( idCategory, ::getCurrentWebName(), 2 )
   ::idTaxRulesGroup    := ::TPrestashopId():getValueTaxRuleGroup( hGet( hProduct, "id_tax_rules_group" ), ::getCurrentWebName() )
   ::idManufacturer     := ::TPrestashopId():getValueManufacturer( hGet( hProduct, "id_manufacturer" ), ::getCurrentWebName() )

   // Publicar el articulo en su categoria-------------------------------------

   idProduct            := ::insertProductPrestashopTable( hProduct, idCategory )

   if empty( idProduct )
      Return ( Self )
   end if 

   ::insertNodeProductCategory( idProduct, idCategory )

   // Publicar el articulo en el root------------------------------------------

   if hGet( hProduct, "lPublicRoot" )
      ::insertNodeProductCategory( idProduct, 2 )
   end if

   ::insertProductShop( idProduct, hProduct )

   ::insertProductLang( idProduct, hProduct )

   ::processImageProducts( idProduct, hProduct )

   ::processPropertyProduct( idProduct, hProduct )

   ::insertReduction( idProduct, hProduct )

   ::processStockProduct( idProduct, hProduct )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertProductPrestashopTable( hProduct, idCategory ) CLASS TComercioProduct

   local cCommand
   local idProduct

   ::writeText( "Añadiendo artículo: " + hGet( hProduct, "description" ) )

   idProduct         := 0

   cCommand          := "INSERT INTO " + ::cPrefixTable( "product" ) + " ( " + ;
                           "id_manufacturer, " + ;
                           "id_tax_rules_group, " + ;
                           "id_category_default, " + ;
                           "id_shop_default, " + ;
                           "quantity, " + ;
                           "minimal_quantity, " + ;
                           "price, " + ;
                           "reference, " + ;
                           "weight, " + ;
                           "active, " + ;
                           "date_add, " + ;
                           "date_upd ) " + ;
                        "VALUES ( " + ;
                           "'" + alltrim( str( ::idManufacturer ) ) + "', " + ;                                   //id_manufacturer
                           "'" + alltrim( str( ::idTaxRulesGroup ) ) + "', " + ;                                  // id_tax_rules_group  - tipo IVA
                           "'" + alltrim( str( ::idCategoryDefault ) ) + "', " + ;                                // id_category_default
                           "'1', " + ;                                                                            // id_shop_default
                           "'1', " + ;                                                                            // quantity
                           "'1', " + ;                                                                            // minimal_quantity
                           "'" + alltrim( str( hGet( hProduct, "price" ) ) ) + "', " + ;                          // price
                           "'" + alltrim( hGet( hProduct, "id" ) ) + "', " + ;                                    // reference
                           "'" + alltrim( str( hGet( hProduct, "weight" ) ) ) + "', " + ;                         // weight
                           "'1', " + ;                                                                            // active
                           "'" + dtos( GetSysDate() ) + "', " + ;                                                 // date_add
                           "'" + dtos( GetSysDate() ) + "' )"

   if ::commandExecDirect( cCommand ) 

      idProduct      := ::oConexionMySQLDatabase():getInsertId()
      
      if !empty( idProduct )
         ::TPrestashopId():setValueProduct( hGet( hProduct, "id" ), ::getCurrentWebName(), idProduct )
      end if 

   else
      
      ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product" ), 3 )

      Return ( idProduct )

   end if

Return ( idProduct )

//---------------------------------------------------------------------------//

METHOD insertProductShop( idProduct, hProduct ) CLASS TComercioProduct

   local cCommand

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product_shop" ) + " ( " +;
                     "id_product, " + ;
                     "id_shop, " + ;
                     "id_category_default, " + ;
                     "id_tax_rules_group, " + ;
                     "on_sale, " + ;
                     "price, " + ;
                     "active, " + ;
                     "date_add, " + ;
                     "date_upd )" + ;
                  " VALUES ( " + ;
                     "'" + alltrim( str( idProduct ) ) + "', " + ;
                     "'1', " + ;
                     "'" + alltrim( str( ::idCategoryDefault ) ) + "', " + ;
                     "'" + alltrim( str( ::idTaxRulesGroup ) ) + "', " + ;
                     "'0', " + ;
                     "'" + alltrim( str( hGet( hProduct, "price" ) ) ) + "', " + ;
                     "'1', " + ;
                     "'" + dtos( GetSysDate() ) + "', " + ;
                     "'" + dtos( GetSysDate() ) + "' )"

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_shop" ), 3 )
   end if

   SysRefresh()

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertProductLang( idProduct, hProduct ) CLASS TComercioProduct

   local cCommand

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product_lang" ) + " ( " +;
                     "id_product, " + ;
                     "id_lang, " + ;
                     "description, " + ;
                     "description_short, " + ;
                     "link_rewrite, " + ;
                     "meta_title, " + ;
                     "meta_description, " + ;
                     "meta_keywords, " + ;
                     "name, " + ;
                     "available_now, " + ;
                     "available_later ) " + ;
                  "VALUES ( " + ;
                     "'" + alltrim( str( idProduct ) ) + "', " + ;                                             // id_product
                     "'" + alltrim( str( ::getLanguage() ) ) + "', " + ;                                       // id_lang
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "description" ) ) + "', " + ; // description
                     "'" + hGet( hProduct, "description_short" ) + "', " + ;                                   // description_short
                     "'" + hGet( hProduct, "link_rewrite" ) + "', " + ;                                        // link_rewrite
                     "'" + hGet( hProduct, "meta_title" ) + "', " + ;                                          // Meta_título
                     "'" + hGet( hProduct, "meta_description" ) + "', " + ;                                    // Meta_description
                     "'" + hGet( hProduct, "meta_keywords" ) + "', " + ;                                       // Meta_keywords
                     "'" + hGet( hProduct, "name" ) + "', " + ;                                                // name
                     "'En stock', " + ;                                                                        // avatible_now
                     "'' )"

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   end if

   SysRefresh()

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertNodeProductCategory( idProduct, idCategory ) CLASS TComercioProduct

   local parentCategory
   local nodeParentCategory

   parentCategory          := ::TComercioCategory():getParentCategory( idCategory )

   ::insertProductCategory( idProduct, parentCategory ) 

   nodeParentCategory      := ::TComercioCategory():getNodeParentCategory( idCategory )

   if !empty( nodeParentCategory )
      ::insertNodeProductCategory( idProduct, nodeParentCategory )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD insertProductCategory( idProduct, idCategory ) CLASS TComercioProduct

   local cCommand := "INSERT INTO " + ::cPrefixTable( "category_product" ) + " ( " + ;
                        "id_category, " + ;
                        "id_product ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( max( idCategory, 1 ) ) ) + "', " + ;
                        "'" + alltrim( str( idProduct ) ) + "' )"

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + str( idProduct ) + " en la tabla " + ::cPrefixTable( "category_product" ), 3 )
      Return ( .f. )
   end if

   SysRefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processImageProducts( idProduct, hProduct ) CLASS TComercioProduct

   local hImage
   local nImagePosition       := 1
   local idImagePrestashop    := 0

   for each hImage in hGet( hProduct, "aImages" )

      // msgalert( idProduct, "idProduct" )

      idImagePrestashop       := ::insertImage( idProduct, hProduct, hImage, nImagePosition )

      // msgalert( idImagePrestashop, "idImagePrestashop" )

      if idImagePrestashop != 0

         ::insertImageLang( hProduct, hImage, idImagePrestashop )

         ::insertImageShop( idProduct, hProduct, hImage, idImagePrestashop )

         // Añadimos la imagen al array para subirla a prestashop--------------

         hSet( hImage, "nTipoImagen", __tipoProducto__ )
         hSet( hImage, "cCarpeta", alltrim( str( idProduct ) ) )
         hSet( hImage, "cPrefijoNombre", alltrim( str( idProduct ) ) )
         hSet( hImage, "aTypeImages", {} )

      end if 

      nImagePosition++

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD insertImage( idProduct, hProduct, hImage, nImagePosition )

   local cCommand
   local idImagePrestashop    := 0

   cCommand := "INSERT INTO " + ::cPrefixTable( "image" ) + " ( " +;
                  "id_product, " + ;
                  "position, " + ;
                  "cover ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( idProduct ) ) + "', " + ;
                  "'" + str( nImagePosition ) + "', " + ;
                  if( hGet( hImage, "lDefault" ), "'1'", "'0'" ) + " )"

   if ::commandExecDirect( cCommand )
      idImagePrestashop       := ::oConexionMySQLDatabase():GetInsertId()
      ::writeText( "Insertado la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image" ), 3 )
   end if

   if !empty( idImagePrestashop )
      ::TPrestashopId():setValueImage( hGet( hProduct, "id" ) + str( hGet( hImage, "id" ), 10 ), ::getCurrentWebName(), idImagePrestashop )
   end if

Return ( idImagePrestashop )

//---------------------------------------------------------------------------//

METHOD insertImageLang( hProduct, hImage, idImagePrestashop )

   local cCommand

   cCommand := "INSERT INTO " + ::cPrefixTable( "image_lang" ) + " ( " +;
                  "id_image, " + ;
                  "id_lang, " + ;
                  "legend ) " + ;
               "VALUES (" + ;
                  "'" + alltrim( str( idImagePrestashop ) ) + "', " + ;
                  "'" + alltrim( str( ::getLanguage() ) ) + "', " + ;
                  "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "name" ) ) + "' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "Insertado la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD insertImageShop( idProduct, hProduct, hImage, idImagePrestashop )

   local cCommand 
   local cNullCover     := "'0'"

   if ::lProductIdColumnImageShop()
      cNullCover        := "null"
   end if 

   cCommand             := "INSERT INTO " + ::cPrefixTable( "image_shop" ) + " ( "  + ;
                              if( ::lProductIdColumnImageShop(), "id_product, ", "" ) + ;
                              "id_image, "                                          + ;
                              "id_shop, "                                           + ;
                              "cover ) "                                            + ;
                           "VALUES ( "                                              + ;
                              if( ::lProductIdColumnImageShop(), "'" + alltrim( str( idProduct ) ) + "', ", "" ) + ;  // id_product
                              "'" + alltrim( str( idImagePrestashop ) ) + "', "     + ;      // id_image
                              "'1', "                                               + ;      // id_shop
                              if( hGet( hImage, "lDefault" ), "'1'", "'0'" ) + ")"           // cover

   if ::commandExecDirect( cCommand )
      ::writeText( "Insertado la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image_shop" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image_shop" ), 3 )
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD processPropertyProduct( idProduct, hProduct ) CLASS TComercioProduct

   local lDefault          := .t.
   local idProperty        := 0
   local priceProperty     := 0

   // Comprobamos si el artículo tiene propiedades y metemos las propiedades

   if ::oPropertyProductDatabase():SeekInOrd( hGet( hProduct, "id" ), "cCodArt" )

      while ::oPropertyProductDatabase():cCodArt == hGet( hProduct, "id" ) .and. !::oPropertyProductDatabase():Eof()

         if !empty( ::oPropertyProductDatabase():cValPr1 )

            priceProperty  := nPrePro( hGet( hProduct, "id" ), ::oPropertyProductDatabase():cCodPr1, ::oPropertyProductDatabase():cValPr1, space( 20 ), space( 20 ), 1, .f., ::oPropertyProductDatabase():cAlias )

            idProperty     := ::insertProductAttributePrestashop( idProduct, hProduct, priceProperty )

            ::insertProductAttributeCombination( ::oPropertyProductDatabase():cCodPr1, ::oPropertyProductDatabase():cValPr1, idProperty )

            if !empty( ::oPropertyProductDatabase():cValPr2 )
            
               ::insertProductAttributeCombination( ::oPropertyProductDatabase():cCodPr2, ::oPropertyProductDatabase():cValPr2, idProperty )

            end if 
            
            ::insertProductAttributeShop( idProduct, idProperty, priceProperty, lDefault )

            ::insertProductAttributeImage( hProduct, idProperty )

         end if 

         ::oPropertyProductDatabase():Skip()

         lDefault    := .f.

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertProductAttributePrestashop( idProduct, hProduct, priceProperty ) CLASS TComercioProduct

   local cCommand
   local idProductAttribute   := 0

   // Metemos la propiedad de éste artículo---------------------------

   cCommand := "INSERT INTO " + ::cPrefixTable( "product_attribute" ) + " ( "                                     + ;
                  if( ::lProductIdColumnProductAttribute(), "id_product, ", "" )                                  + ;
                  "price, "                                                                                       + ;
                  "wholesale_price, "                                                                             + ;
                  "quantity, "                                                                                    + ;
                  "minimal_quantity ) "                                                                           + ;
               "VALUES ( "                                                                                        + ;
                  if( ::lProductIdColumnProductAttribute(), "'" + alltrim( str( idProduct ) ) + "', ", "" )       + ;      //id_product
                  "'" + alltrim( str( priceProperty ) ) + "', "                                                   + ;      //price
                  "'" + alltrim( str( priceProperty ) ) + "', "                                                   + ;      //wholesale_price
                  "'10000', "                                                                                     + ;      //quantity
                  "'1' )"                                                                                                  //minimal_quantity

   if ::commandExecDirect( cCommand )
      idProductAttribute      := ::oConexionMySQLDatabase():GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + alltrim( ::oPropertyProductDatabase():cValPr1 ) + " - " + alltrim( ::oPropertyProductDatabase():cValPr2 ) + " en la tabla " + ::cPrefixTable( "product_attribute" ), 3 )
   end if

Return ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeCombination( idFirstProperty, valueFirstProperty, idProperty ) CLASS TComercioProduct

   local cCommand

   if !( ::oPropertiesLinesDatabase():seekInOrd( upper( idFirstProperty ) + upper( valueFirstProperty ), "cCodPro" ) )
      ::writeText( "Error al buscar en tabla de propiedades " + alltrim( idFirstProperty ) + " : " + alltrim( valueFirstProperty ), 3 )
      Return .f.
   end if 

   cCommand := "INSERT INTO " +  ::cPrefixtable( "product_attribute_combination" ) + "( " + ;
                  "id_attribute, "                                                        + ;
                  "id_product_attribute ) "                                               + ;
               "VALUES ("                                                                 + ;
                  "'" + alltrim( str( ::TPrestashopId():getValueAttribute( idFirstProperty + valueFirstProperty, ::getCurrentWebName() ) ) ) + "', " + ;  //id_attribute
                  "'" + alltrim( str( idProperty ) ) + "' )"                        //id_product_attribute

   if !::commandExecDirect( cCommand ) 
      ::writeText( "Error al insertar la propiedad " + alltrim( ::oPropertiesLinesDatabase():cDesTbl ) + " en la tabla " + ::PrefixTable( "product_attribute_combination" ), 3 )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeShop( idProduct, idProperty, priceProperty, lDefault ) CLASS TComercioProduct

   local cCommand := "INSERT INTO " + ::cPrefixTable( "product_attribute_shop" ) + " ( "  + ;
                        if( ::lProductIdColumnProductAttributeShop, "id_product, ", "" )  + ;
                        "id_product_attribute, "                                          + ;
                        "id_shop, "                                                       + ;
                        "wholesale_price, "                                               + ;
                        "price, "                                                         + ;
                        "ecotax, "                                                        + ;
                        "weight, "                                                        + ;
                        "unit_price_impact, "                                             + ;
                        if( lDefault, "default_on, ", "" )                                + ;
                        "minimal_quantity ) "                                             + ;
                     "VALUES ( "                                                          + ;
                        if( ::lProductIdColumnProductAttributeShop(), "'" + alltrim( str( idProduct ) ) + "', ", "" ) + ;  // id_product
                        "'" + alltrim( str( idProperty ) ) + "', "                        + ;
                        "'1', "                                                           + ;
                        "'" + alltrim( str( priceProperty ) ) + "', "                     + ;
                        "'" + alltrim( str( priceProperty ) ) + "', "                     + ;
                        "'0', "                                                           + ;
                        "'0', "                                                           + ;
                        "'0', "                                                           + ;
                        if( lDefault, "'1',", "" )                                        + ;
                        "'1' )"

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar la propiedad " + alltrim( ::oPropertiesLinesDatabase():cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_shop" ), 3 )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeImage( hProduct, idProductAttribute ) CLASS TComercioProduct

   local hImage
   local aImages
   local cCommand
   local nIdProductImage

   aImages                 := hget( hProduct, "aImages" )

   if empty( aImages )
      Return ( self )
   end if 

   for each hImage in aImages

      nIdProductImage   := ::TPrestashopId():getValueImage( hGet( hProduct, "id" ) + str( hget( hImage, "id" ), 10 ), ::getCurrentWebName() )

      cCommand          := "INSERT INTO " + ::cPrefixTable( "product_attribute_image" ) + " ( " + ;
                              "id_product_attribute, "                                          + ;
                              "id_image ) "                                                     + ;
                           "VALUES ( "                                                          + ;
                              "'" + alltrim( str( idProductAttribute ) ) + "', "                + ;   // id_product_attribute
                              "'" + alltrim( str( nIdProductImage ) ) + "' )"                         // id_image

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )
      end if

   next   

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteProduct( hProduct ) CLASS TComercioProduct

   local oQuery
   local oQuery2
   local cCommand                      
   local idDelete                      := 0
   local idDelete2                     := 0
   local idProductGestool              := hget( hProduct, "id" )
   local idProductPrestashop 

   if empty( ::TPrestashopId():getValueProduct( idProductGestool, ::getCurrentWebName() ) ) 
      Return ( Self )
   end if 

   idProductPrestashop          := alltrim( str( ::TPrestashopId():getValueProduct( idProductGestool, ::getCurrentWebName() ) ) )

   if empty( idProductPrestashop )
      Return ( Self )
   end if

   ::writeText( "Eliminando artículo de Prestashop" )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando adjuntos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attachment" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando impuestos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_country_tax" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando archivos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_download" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando cache de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_group_reduction_cache" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando multitienda de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_shop" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando descripciones de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_lang" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando ofertas de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_sale" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando etiquetas de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_tag" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando complementos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_supplier" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando transporte de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_carrier" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando atributos de Prestashop"  )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "product_attribute" ) +  ' WHERE id_product=' + idProductPrestashop
   oQuery            := ::queryExecDirect( cCommand )
   
   ::writeText( "Eliminando lineas atributos de Prestashop"  )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      while !oQuery:Eof()

         idDelete    := oQuery:FieldGet( 1 )

         if !empty( idDelete )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product_attribute = " + alltrim( str( idDelete ) )
            ::commandExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute = " + alltrim( str( idDelete ) )
            ::commandExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_image" ) + " WHERE id_product_attribute = " + alltrim( str( idDelete ) )
            ::commandExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_shop" ) + " WHERE id_product_attribute = " + alltrim( str( idDelete ) )
            ::commandExecDirect( cCommand )

         end if

         oQuery:Skip()

         SysRefresh()

      end while

   end if

   ::writeText( "Eliminando precios especificos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando prioridad de precio de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price_priority" ) + " WHERE id_product = " + idProductPrestashop
   ::commandExecDirect( cCommand )

   ::writeText( "Eliminando funciones de Prestashop"  )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "feature_product" ) +  ' WHERE id_product=' + idProductPrestashop
   oQuery            := ::queryExecDirect( cCommand )
   
   ::writeText( "Eliminando lineas funciones de Prestashop"  )

   if oQuery:Open() .and. oQuery:RecCount() > 0
   
      oQuery:GoTop()
      while !oQuery:Eof()

         idDelete    := oQuery:FieldGet( 1 )

         if !empty( idDelete )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_product" ) + " WHERE id_product = " + idProductPrestashop
            ::commandExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature" ) + " WHERE id_feature = " + alltrim( str( idDelete ) )
            ::commandExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_lang" ) + " WHERE id_feature = " + alltrim( str( idDelete ) )
            ::commandExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_shop" ) + " WHERE id_feature = " + alltrim( str( idDelete ) )
            ::commandExecDirect( cCommand )

            cCommand          := "SELECT * FROM " + ::cPrefixTable( "feature_value" ) +  " WHERE id_feature = " + alltrim( str( idDelete ) )
            oQuery2           := ::queryExecDirect( cCommand )

            if oQuery2:Open() .and. oQuery2:RecCount() > 0

               oQuery2:GoTop()
               while !oQuery2:Eof()

                  idDelete2   := oQuery:FieldGet( 1 )

                  if !empty( idDelete2 )

                     cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value" ) + " WHERE id_feature_value = " + alltrim( str( idDelete2 ) )
                     ::commandExecDirect( cCommand )

                     cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value_lang" ) + " WHERE id_feature_value = " + alltrim( str( idDelete2 ) )
                     ::commandExecDirect( cCommand )

                  end if

                  oQuery2:Skip()

                  SysRefresh()

               end while      

            end if

         end if

         oQuery:Skip()

         SysRefresh()

      end while      

   end if

   sysrefresh()

   // Eliminamos las imágenes del artículo---------------------------------------

   ::writeText( "Eliminando imágenes de prestashop" )

   ::deleteImages( idProductPrestashop )

   // Quitamos la referencia de nuestra tabla-------------------------------------

   ::writeText( "Eliminando referencias en gestool" )

   ::TPrestashopId():deleteDocumentValuesProduct( idProductGestool, ::getCurrentWebName() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD deleteImages( idProductPrestashop ) CLASS TComercioProduct

   local idDelete
   local oQuery
   local cCommand    := ""

   if empty( idProductPrestashop )
      Return ( Self )   
   end if 
      
   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "image" ) +  ' WHERE id_product=' + idProductPrestashop
   oQuery            := ::queryExecDirect( cCommand )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      while !oQuery:Eof()

         idDelete    := oQuery:FieldGet( 1 )

         cCommand    := "DELETE FROM " + ::cPrefixTable( "image" ) + " WHERE id_image = " + alltrim( str( idDelete ) )
         ::commandExecDirect( cCommand )

         cCommand    := "DELETE FROM " + ::cPrefixTable( "image_shop" ) + " WHERE id_image = " + alltrim( str( idDelete ) )
         ::commandExecDirect( cCommand )

         cCommand    := "DELETE FROM " + ::cPrefixTable( "image_lang" ) + " WHERE id_image = " + alltrim( str( idDelete ) )
         ::commandExecDirect( cCommand )
      
         oQuery:Skip()

         SysRefresh()

      end while

   end if

   oQuery:Free()

Return nil

//---------------------------------------------------------------------------//

METHOD uploadImagesToPrestashop() CLASS TComercioProduct

   local hProduct
   local nProducts   := len( ::aProducts )

   ::meterProcesoSetTotal( nProducts )

   for each hProduct in ::aProducts

      ::uploadImageToPrestashop( hProduct )

      ::meterProcesoText( "Subiendo imagenes " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) )
   
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD uploadImageToPrestashop( hProduct ) CLASS TComercioProduct

   local cTypeImage
   local hProductImage
   local aProductsImages   := hGet( hProduct, "aImages" )

   if empty( aProductsImages )
      Return ( nil )
   end if 

   CursorWait()

   // Subimos los ficheros de imagenes-----------------------------------

   ::meterProcesoSetTotal( len( aProductsImages ) )

   for each hProductImage in aProductsImages

      ::buildFilesProductImages( hProductImage )

      ::ftpUploadFilesProductImages( hProductImage )

   next

   CursorWe()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD buildFilesProductImages( hProductImage ) CLASS TComercioProduct

   local rootImage
   local fileImage         
   local oTipoImage

   CursorWait()

   rootImage               := cPatTmp() + hget( hProductImage, "cPrefijoNombre" ) + ".jpg"

   saveImage( hget( hProductImage, "name" ), rootImage )

   for each oTipoImage in ::aTypeImagesPrestashop()

      if hget( hProductImage, "nTipoImagen" ) == __tipoProducto__ .and. oTipoImage:lProducts

         fileImage         := cPatTmp() + hget( hProductImage, "cPrefijoNombre" ) + "-" + oTipoImage:cNombreTipo + ".jpg"

         saveImage( rootImage, fileImage, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

         aadd( hget( hProductImage, "aTypeImages" ), fileImage )

         SysRefresh()

      end if 

   next

   CursorWe()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD ftpUploadFilesProductImages( hProductImage ) CLASS TComercioProduct

   local cTypeImage

   for each cTypeImage in hget( hProductImage, "aTypeImages" )

      ::meterProcesoText( "Subiendo imagen " + cTypeImage + " en directorio " + ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) )

      ::oFtp():CreateFile( cTypeImage, ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) )
 
      SysRefresh()

      ferase( cTypeImage )

      SysRefresh()

   next 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD insertAditionalInformation() CLASS TComercioProduct

   local hTax
   local hCategory
   local hManufacturer
   local hPropertiesHeaderProduct
   local hPropertiesLineProduct

   // Subimos los tipos de IVA----------------------------------------------

   ::meterProcesoSetTotal( len( ::aTaxProducts ) )

   for each hTax in ::aTaxProducts

      ::insertTaxPrestashop( hTax )

      ::meterProcesoText( "Subiendo impuestos " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aTaxProducts))) )

   next

   // Subimos fabricantes---------------------------------------------------

   if ::TPrestashopConfig():getSyncronizeManufacturers()

      ::meterProcesoSetTotal( len( ::aManufacturersProduct ) )

      for each hManufacturer in ::aManufacturersProduct

         ::insertManufacturersPrestashop( hManufacturer )

         ::meterProcesoText( "Subiendo fabricantes " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aManufacturersProduct))) )

      next 

   end if 

   // Subimos las cabeceras de propiedades necesarias-----------------------

   ::meterProcesoSetTotal( len( ::aPropertiesHeaderProduct ) )

   for each hPropertiesHeaderProduct in ::aPropertiesHeaderProduct

      ::insertPropertiesHeader( hPropertiesHeaderProduct )

      ::meterProcesoText( "Subiendo propiedad " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aPropertiesHeaderProduct))) )

   next

   // Subimos las Lineas de propiedades necesarias--------------------------

   ::meterProcesoSetTotal( len( ::aPropertiesLineProduct ) )

   asort( ::aPropertiesLineProduct, , , {|x,y| hget( x, "position" ) < hget( y, "position" ) } )

   for each hPropertiesLineProduct in ::aPropertiesLineProduct

      ::insertPropertiesLineProduct( hPropertiesLineProduct, hb_enumindex() )

      ::meterProcesoText( "Subiendo propiedad " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aPropertiesLineProduct))) )

   next
 
Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertTaxPrestashop( hTax ) CLASS TComercioProduct

   local cCommand          := ""  
   local idTax             := 0
   local idGroupWeb        := 0

   cCommand := "INSERT INTO " + ::cPreFixtable( "tax" ) + " ( " + ;
                  "rate, " + ;
                  "active ) " + ;
               "VALUES ( " + ;
                  "'" + hGet( hTax, "rate" ) + "', " + ;    // rate
                  "'1' )"                                   // active

   if ::commandExecDirect( cCommand )
      idTax                := ::oConexionMySQLDatabase():GetInsertId()
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax" ) )
      Return .f.
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_lang------------------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_lang" ) + "( " +;
                  "id_tax, " + ;
                  "id_lang, " + ;
                  "name ) " + ;
               "VALUES ( " + ;
                  "'" + str( idTax ) + "', " + ;                           // id_tax
                  "'" + str( ::getLanguage() ) + "', " + ;                     // id_lang
                  "'" + ::oConexionMySQLDatabase():Escapestr( hGet( hTax, "name" ) ) + "' )"   // name

   if ::commandExecDirect( cCommand )
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule_group------------------
   */

   cCommand := "INSERT INTO "+ ::cPrefixTable( "tax_rules_group" ) + "( " + ;
                  "name, " + ;
                  "active ) " + ;
               "VALUES ( " + ;
                  "'" + ::oConexionMySQLDatabase():Escapestr( hGet( hTax, "name" ) ) + "', " + ;  // name
                  "'1' )"                                                     // active

   if ::commandExecDirect( cCommand )
      idGroupWeb           := ::oConexionMySQLDatabase():GetInsertId()
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_rule" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_country, " + ;
                  "id_tax ) " + ;
               "VALUES ( " + ;
                  "'" + str( idGroupWeb ) + "', " + ;       // id_tax_rules_group
                  "'6', " + ;                               // id_country - 6 es el valor de España
                  "'" + str( idTax ) + "' )"                // id_tax

   if !::commandExecDirect( cCommand )
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_rules_group_shop" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_shop ) " + ;
               "VALUES ( " + ;
                  "'" + str( idGroupWeb ) + "', " + ;
                  "'1' )"

   if !::commandExecDirect( cCommand )
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rules_group_shop" ) )
   end if

   // Guardo referencia a la web-----------------------------------------------

   ::TPrestashopId():setValueTax(           hGet( hTax, "id" ), ::getCurrentWebName(), idTax )
   ::TPrestashopId():setValueTaxRuleGroup(  hGet( hTax, "id" ), ::getCurrentWebName(), idTax )

Return ( idTax )

//---------------------------------------------------------------------------//

METHOD insertManufacturersPrestashop( hFabricantesData ) CLASS TComercioProduct

   local oImagen
   local cCommand    := ""    
   local nCodigoWeb  := 0
   local nParent     := 1

   /*
   Insertamos un fabricante nuevo en las tablas de prestashop-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "manufacturer" ) + "( " +;
                  "name, " + ;
                  "date_add, " + ;
                  "date_upd, " + ;
                  "active ) " + ;
               "VALUES ( " + ;
                  "'" + hGet( hFabricantesData, "name" ) + "', " + ; //name
                  "'" + dtos( GetSysDate() ) + "', " + ;             //date_add
                  "'" + dtos( GetSysDate() ) + "', " + ;             //date_upd
                  "'1' )"                                            //active

   if ::commandExecDirect( cCommand )
      nCodigoWeb           := ::oConexionMySQLDatabase():GetInsertId()
   else
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla " + ::cPreFixtable( "manufacturer" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "manufacturer_shop" ) + "( "+ ;
                  "id_manufacturer, " + ;
                  "id_shop ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;      // id_manufacturer
                  "'1' )"                                             // id_shop                  


   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla" + ::cPreFixtable( "manufacturer_shop" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPreFixtable( "manufacturer_lang" ) + "( " +;
                  "id_manufacturer, " + ;
                  "id_lang ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;     //id_manufacturer
                  "'" + str( ::nLanguage ) + "' )"                   //id_lang

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla" + ::cPreFixtable( "manufacturer_lang" ), 3 )
   end if

   // Guardo referencia a la web-----------------------------------------------

   if !empty( nCodigoWeb )
      ::TPrestashopId():setValueManufacturer( hget( hFabricantesData, "id" ), ::getCurrentWebName(), nCodigoWeb )
   end if 

return nCodigoWeb

//---------------------------------------------------------------------------//

METHOD insertPropertiesHeader( hPropertiesHeaderProduct ) CLASS TComercioProduct

   local cCommand          := ""
   local idPrestashop      := 0

   cCommand                := "INSERT INTO " + ::cPrefixTable( "attribute_group" ) + " ( " +; 
                                 "is_color_group, " + ;
                                 "group_type ) " + ;
                              "VALUES ( " + ;
                                 "'" + if( hGet( hPropertiesHeaderProduct, "lColor" ), "1", "0" ) + "', " + ;         // is_color_group
                                 "'" + if( hGet( hPropertiesHeaderProduct, "lColor" ), "color", "select" ) + "' )"    // group_type                        

   if ::commandExecDirect( cCommand )
      idPrestashop         := ::oConexionMySQLDatabase():GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesHeaderProduct, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_group" ), 3 )
   end if

   if !empty( idPrestashop )
      cCommand             := "INSERT INTO " + ::cPrefixTable( "attribute_group_lang" ) + " ( " + ; 
                                 "id_attribute_group, " + ;
                                 "id_lang, " + ;
                                 "name, " + ;
                                 "public_name ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( idPrestashop ) ) + "', " + ;            // id_attribute_group
                                 "'" + str( ::getLanguage() ) + "', " + ;                    // id_lang
                                 "'" + hGet( hPropertiesHeaderProduct, "name" ) + "', " + ;  // name
                                 "'" + hGet( hPropertiesHeaderProduct, "name" ) + "' )"      // public_name

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesHeaderProduct, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_group_lang" ), 3 )
      end if

      // Guardo referencia a la web-----------------------------------------------

      ::TPrestashopId():setValueAttributeGroup( hget( hPropertiesHeaderProduct, "id" ), ::getCurrentWebName(), idPrestashop )

   end if 

Return self

//---------------------------------------------------------------------------//

METHOD insertPropertiesLineProduct( hPropertiesLineProduct, nPosition ) CLASS TComercioProduct

   local idPrestashop      := 0
   local cCommand          := ""
   local nCodigoGrupo      := ::TPrestashopId():getValueAttributeGroup( hGet( hPropertiesLineProduct, "idparent" ), ::getCurrentWebName() )

   cCommand                := "INSERT INTO " + ::cPrefixTable( "attribute" ) + " ( " + ; 
                                 "id_attribute_group, " + ;
                                 "color, " + ;
                                 "position ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( nCodigoGrupo ) ) + "', " + ;
                                 "'" + hGet( hPropertiesLineProduct, "color" ) + "' ," + ;
                                 "'" + alltrim( str( nPosition ) ) + "' )"                // posicion

   if ::commandExecDirect( cCommand )
      idPrestashop   := ::oConexionMySQLDatabase():GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesLineProduct, "name" ) + " en la tabla " + ::cPreFixtable( "attribute" ), 3 )
   end if

   if !empty( idPrestashop )

      cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute_lang" ) + " ( " + ;
                        "id_attribute, " + ;
                        "id_lang, " + ;
                        "name ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( idPrestashop ) ) + "', " + ;                                             // id_attribute
                        "'" + str( ::getLanguage() ) + "', " + ;                                                     // id_lang
                        "'" + ::oConexionMySQLDatabase():Escapestr( hGet( hPropertiesLineProduct, "name" ) ) + "' )" // name

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesLineProduct, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_lang" ), 3 )
      end if

      cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute_shop" ) + " ( " + ;
                        "id_attribute, " + ;
                        "id_shop ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( idPrestashop ) ) + "', " + ;   // id_attribute
                        "'1' )"                                            // id_shop

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesLineProduct, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_shop" ), 3 )
      end if

      // Guardo referencia a la web-----------------------------------------------

      ::TPrestashopId():setValueAttribute( hGet( hPropertiesLineProduct, "idparent" ) + hGet( hPropertiesLineProduct, "id" ), ::getCurrentWebName(), idPrestashop )

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD getTotalStock( aStock ) CLASS TComercioProduct

   local hStock
   local nTotalStock := 0

   for each hStock in aStock
      nTotalStock    += hGet( hStock, "unitStock" )
   next 

Return ( nTotalStock )

//---------------------------------------------------------------------------//

METHOD insertReduction( idProduct, hProduct ) CLASS TComercioProduct

   local cCommand       := ""

   if hGet( hProduct, "specific_price" ) .and. hGet( hProduct, "reduction" ) != 0

      cCommand          := "INSERT INTO " + ::cPrefixTable( "specific_price" ) + " ( " + ; 
                              "id_specific_price_rule, " + ;
                              "id_cart, " + ;
                              "id_product, " + ;
                              "id_shop, " + ;
                              "id_shop_group, " + ;
                              "id_currency, " + ;
                              "id_country, " + ;
                              "id_group, " + ;
                              "id_customer, " + ;
                              "id_product_attribute, " + ;
                              "price, " + ;
                              "from_quantity, " + ;
                              "reduction, " + ;
                              if( ::lSpecificPriceIdColumnReductionTax, "reduction_tax, ", "" ) + ;
                              "reduction_type ) " + ;
                           "VALUES ( " + ;
                              "'0', " + ;                                                                                                                // id_specific_price_rule
                              "'0', " + ;                                                                                                                // id_cart
                              "'" + alltrim( str( idProduct ) ) + "', " + ;                                                                             // id_product
                              "'1', " + ;                                                                                                                // id_shop
                              "'0', " + ;                                                                                                                // id_shop_group
                              "'0', " + ;                                                                                                                // id_currency
                              "'0', " + ;                                                                                                                // id_country
                              "'0', " + ;                                                                                                                // id_group
                              "'0', " + ;                                                                                                                // id_customer
                              "'0', " + ;                                                                                                                // id_product_attribute
                              "'-1', " + ;                                                                                                               // price
                              "'1', " + ;                                                                                                                // from_quantity
                              "'" + alltrim( str( hGet( hProduct, "reduction" ) ) ) + "', " + ;                                                     // reduction
                              if( ::lSpecificPriceIdColumnReductionTax, "'" + alltrim( str( hGet( hProduct, "reduction_tax" ) ) ) + "', ", "" ) + ; // reduction_tax
                              "'amount' )"                                                                                                               // reduction_type
   
      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar una oferta de " + hGet( hProduct, "name" ), 3 )
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD processStockProduct( idProduct, hProduct ) CLASS TComercioProduct

   local hStock

   for each hStock in hGet( hProduct, "aStock" )
      ::insertStockProduct( hStock )
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertStockProduct( hStock ) CLASS TComercioProduct

   local cText
   local cCommand
   local unitStock               
   local idProductPrestashop     
   local attributeFirstProperty  
   local attributeSecondProperty 
   local idProductAttribute      := 0

   idProductPrestashop           := ::TPrestashopId():getValueProduct( hget( hStock, "idProduct" ), ::getCurrentWebName() )
   attributeFirstProperty        := ::TPrestashopId():getValueAttribute( hget( hStock, "idFirstProperty" ) + hget( hStock, "valueFirstProperty" ),     ::getCurrentWebName() )
   attributeSecondProperty       := ::TPrestashopId():getValueAttribute( hget( hStock, "idSecondProperty" ) + hget( hStock, "valueSecondProperty" ),   ::getCurrentWebName() ) 
   unitStock                     := hget( hStock, "unitStock" )

   if ( attributeFirstProperty != 0 ) .and. ( attributeSecondProperty != 0 )
      idProductAttribute         := ::getProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty ) 
   end if 

   cCommand                      := "DELETE FROM " + ::cPrefixTable( "stock_available" ) + " "                          + ;
                                    "WHERE id_product = " + alltrim( str( idProductPrestashop ) ) + " "                 + ;
                                    "AND id_product_attribute = " + alltrim( str( idProductAttribute ) )

   ::commandExecDirect( cCommand )

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

      ::commandExecDirect( cCommand )

   end if

   cText       := "Actualizando stock con propiedades : " + alltrim( str( attributeFirstProperty ) ) + " , " + alltrim( str( attributeSecondProperty ) ) + ", "
   cText       += "cantidad : " + alltrim( str( unitStock ) )

   ::writeText( cText )

Return .t.   

//---------------------------------------------------------------------------//

METHOD getProductAttribute( idProductPrestashop, cCodWebValPr1, cCodWebValPr2 ) CLASS TComercioProduct

   local idProductAttribute   := 0
   local cCommand             := ""
   local oQuery
   local oQueryCombination
   local lPrp1                := .f.
   local lPrp2                := .f.

   do case
      case !empty( cCodWebValPr1 ) .and. empty( cCodWebValPr2 )

         cCommand             := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product = " + alltrim( str( idProductPrestashop ) )

         oQuery               := ::queryExecDirect( cCommand )

         if oQuery:Open() .and. oQuery:recCount() > 0

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand       := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute = " + alltrim( str( oQuery:FieldGet( 1 ) ) )

               oQueryCombination        := ::queryExecDirect( cCommand )

                  if oQueryCombination:Open() .and. oQueryCombination:recCount() == 1 .and. oQueryCombination:FieldGet( 1 ) == cCodWebValPr1
                     idProductAttribute     := oQuery:FieldGet( 1 )
                  end if   

               oQuery:Skip()

            end while

         end if

      case !empty( cCodWebValPr1 ) .and. !empty( cCodWebValPr2 )

         cCommand                := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product = " + alltrim( str( idProductPrestashop ) )

         oQuery                  := ::queryExecDirect( cCommand )

         if oQuery:Open() // .and. oQuery:recCount() > 0

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand          := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + alltrim( str( oQuery:FieldGet( 1 ) ) )

               oQueryCombination           := ::queryExecDirect( cCommand )

                  if oQueryCombination:Open() .and. oQueryCombination:recCount() == 2

                     oQueryCombination:GoTop()
                     while !oQueryCombination:Eof()

                        if !lPrp1
                           lPrp1 := ( oQueryCombination:FieldGet( 1 ) == cCodWebValPr1 )
                        end if

                        oQueryCombination:Skip()

                     end while

                     oQueryCombination:GoTop()
                     while !oQueryCombination:Eof()

                        if !lPrp2
                           lPrp2 := ( oQueryCombination:FieldGet( 1 ) == cCodWebValPr2 )
                        end if

                        oQueryCombination:Skip()

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

Return ( idProductAttribute )

//---------------------------------------------------------------------------//



