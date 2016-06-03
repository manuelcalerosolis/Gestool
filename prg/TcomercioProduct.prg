#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define __tipoProducto__      1
#define __tipoCategoria__     2     

//---------------------------------------------------------------------------//

CLASS TComercioProduct

   DATA  TComercio

   DATA  aProducts                                          INIT {}
   DATA  aIvaProducts                                       INIT {}
   DATA  aManufacturerProduct                               INIT {}
   DATA  aCategoryProduct                                   INIT {}
   DATA  aPropertiesHeaderProduct                           INIT {}
   DATA  aPropertiesLineProduct                             INIT {}

   DATA  idCategoryDefault  
   DATA  idTaxRulesGroup 
   DATA  idManufacturer    

   METHOD New( TComercio )                                  CONSTRUCTOR

   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                                   INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                               INLINE ( ::TComercio:TPrestashopConfig )

   METHOD isSyncronizeAll()                                 INLINE ( ::TComercio:lSyncAll )
   METHOD getLanguage()                                     INLINE ( ::TComercio:nLanguage )

   METHOD getCurrentWebName()                               INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                                INLINE ( ::TComercio:writeText( cText ) )

   METHOD oStock()                                          INLINE ( ::TComercio:oStock )

   METHOD oConexionMySQLDatabase()                          INLINE ( ::TComercio:oCon )

   METHOD cPrefixtable( cTable )                            INLINE ( ::TComercio:cPrefixTable( cTable ) )

   METHOD meterTotalText( cText )                           INLINE ( ::TComercio:meterTotalText( cText ) )
   METHOD meterTotalSetTotal( nTotal )                      INLINE ( ::TComercio:meterTotalSetTotal( nTotal ) )
   METHOD meterProcesoText( cText )                         INLINE ( ::TComercio:meterProcesoText( cText ) )
   METHOD meterProcesoSetTotal( nTotal )                    INLINE ( ::TComercio:meterProcesoSetTotal( nTotal ) )

   METHOD lProductIdColumnImageShop()                       INLINE ( ::TComercio:lProductIdColumnImageShop )   
   METHOD lProductIdColumnProductAttribute()                INLINE ( ::TComercio:lProductIdColumnProductAttribute )   
   METHOD lProductIdColumnProductAttributeShop()            INLINE ( ::TComercio:lProductIdColumnProductAttributeShop )   
   METHOD lSpecificPriceIdColumnReductionTax()              INLINE ( ::TComercio:lSpecificPriceIdColumnReductionTax )   
   METHOD aTypeImagesPrestashop()                           INLINE ( ::TComercio:aTypeImagesPrestashop )   

   METHOD oProductDatabase()                                INLINE ( ::TComercio:oArt )
   METHOD oIvaDatabase()                                    INLINE ( ::TComercio:oIva )
   METHOD oManufacturerDatabase()                           INLINE ( ::TComercio:oFab )
   METHOD oCustomerDatabase()                               INLINE ( ::TComercio:oCli )
   METHOD oAddressDatabase()                                INLINE ( ::TComercio:oObras )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )
   METHOD oCategoryDatabase()                               INLINE ( ::TComercio:oFam )
   METHOD oPropertyDatabase()                               INLINE ( ::TComercio:oPro )
   METHOD oPropertiesLinesDatabase()                        INLINE ( ::TComercio:oTblPro )
   METHOD oPropertyProductDatabase()                        INLINE ( ::TComercio:oArtDiv )
   METHOD oImageProductDatabase()                           INLINE ( ::TComercio:oArtImg )

   METHOD oFtp()                                            INLINE ( ::TComercio:oFtp )
   METHOD cDirectoryProduct()                               INLINE ( ::TComercio:cDirectoryProduct() )
   METHOD cDirectoryCategories()                            INLINE ( ::TComercio:cDirectoryCategories() )
   METHOD getRecursiveFolderPrestashop( cCarpeta )          INLINE ( ::TComercio:getRecursiveFolderPrestashop( cCarpeta ) )

   METHOD commandExecDirect( cCommand )                     INLINE ( TMSCommand():New( ::oConexionMySQLDatabase() ):ExecDirect( cCommand ) )
   METHOD queryExecDirect( cQuery )                         INLINE ( TMSQuery():New( ::oConexionMySQLDatabase(), cQuery ) )

   METHOD isProductInCurrentWeb()                           

   METHOD buildProductInformation( idProduct )
      METHOD buildIvaProducts( id )  
      METHOD buildManufacturerProduct( id )
      METHOD buildCategoryProduct( id )
      METHOD buildPropertyProduct( id )
      METHOD buildProduct( id )

      METHOD getPrice()
      METHOD getPriceReduction()
      METHOD getPriceReductionTax()                         INLINE ( iif(  ::oProductDatabase():lIvaWeb, 1, 0 ) )
      METHOD getDescription()                               INLINE ( iif(  !empty( ::oProductDatabase():mDesTec ),;
                                                                           alltrim( ::oProductDatabase():mDesTec ),;
                                                                           alltrim( ::oProductDatabase():Nombre ) ) )

      METHOD imagesProduct( id )
      METHOD stockProduct( id )

   METHOD uploadProductsToPrestashop()
      METHOD uploadProductToPrestashop()
         METHOD insertProductPrestashopTable( hProduct )
         
         METHOD insertCategoryProduct( idProduct, idCategory ) 
            METHOD insertNodeCategoryProduct( idProduct, idCategory ) 
            METHOD getParentCategory( idCategory ) 
            METHOD getNodeParentCategory( idCategory )
         
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

   METHOD truncteAllTables() 
      METHOD truncateTable( cTable )   

   METHOD insertRootCategory() 

   METHOD deleteProduct( hProduct )
   METHOD deleteImages( idProductPrestashop )

   METHOD cleanGestoolReferences()

   METHOD uploadImagesToPrestashop()
      METHOD uploadImageToPrestashop( hProduct )
         METHOD buildFilesProductImages( hProductImage )
         METHOD ftpUploadFilesProductImages( hProductImage )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioProduct

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildProductInformation( idProduct ) CLASS TComercioProduct

   if !( ::isProductInCurrentWeb( idProduct ) )
      Return .f.
   end if 

   ::writeText( alltrim( ::oProductDatabase():Codigo ) + " - " + alltrim( ::oProductDatabase():Nombre ) )

   ::buildIvaProducts(           ::oProductDatabase():TipoIva )
   ::buildManufacturerProduct(   ::oProductDatabase():cCodFab )
   ::buildCategoryProduct(       ::oProductDatabase():Familia )
   ::buildPropertyProduct(       ::oProductDatabase():Codigo )
   ::buildProduct(               ::oProductDatabase():Codigo )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD isProductInCurrentWeb( idProduct ) CLASS TComercioProduct

   if !( ::oProductDatabase():seekInOrd( idProduct, "Codigo" ) )
      ::writeText( "Artículo " + alltrim( idProduct ) + " no encontrado" )
      Return .f.
   end if 

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

   if aScan( ::aIvaProducts, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f. 
   end if 
   
   if ::TPrestashopId():getValueTax( id, ::getCurrentWebName() ) == 0
      if ::oIvaDatabase():seekInOrd( id, "Tipo" )
         aadd( ::aIvaProducts,   {  "id"     => id,;
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

   if aScan( ::aManufacturerProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if 

   if ::TPrestashopId():getValueManufacturer( id, ::getCurrentWebName() ) == 0
      if ::oManufacturerDatabase():SeekInOrd( id, "cCodFab" ) .and. ::oManufacturerDatabase():lPubInt
         aadd( ::aManufacturerProduct, {  "id"     => id,;
                                          "name"   => rtrim( ::oManufacturerDatabase():cNomFab ) } )
      end if
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildCategoryProduct( id ) CLASS TComercioProduct

   if !( ::isSyncronizeAll() )
      Return .f. 
   end if 

   if ascan( ::aCategoryProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if

   if ::TPrestashopId():getValueCategory( id, ::getCurrentWebName() ) == 0
   
      if ::oCategoryDatabase():SeekInOrd( id, "cCodFam" ) 
   
         aAdd( ::aCategoryProduct,  {  "id"           => id,;
                                       "id_parent"    => ::oCategoryDatabase():cFamCmb,;
                                       "name"         => if( empty( ::oCategoryDatabase():cDesWeb ), alltrim( ::oCategoryDatabase():cNomFam ), alltrim( ::oCategoryDatabase():cDesWeb ) ),;
                                       "description"  => if( empty( ::oCategoryDatabase():cDesWeb ), alltrim( ::oCategoryDatabase():cNomFam ), alltrim( ::oCategoryDatabase():cDesWeb ) ),;
                                       "link_rewrite" => cLinkRewrite( if( empty( ::oCategoryDatabase():cDesWeb ), alltrim( ::oCategoryDatabase():cNomFam ), alltrim( ::oCategoryDatabase():cDesWeb ) ) ),;
                                       "image"        => ::oCategoryDatabase():cImgBtn } )
   
      end if   

      if !empty( ::oCategoryDatabase():cFamCmb )
         ::buildCategoryProduct( ::oCategoryDatabase():cFamCmb )
      end if

   end if 

Return ( Self )

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

METHOD buildProduct( id ) CLASS TComercioProduct

   local aStockArticulo       := {}
   local aImagesArticulos     := {}

   if aScan( ::aProducts, {|h| hGet( h, "id" ) == id } ) != 0
      Return ( self )
   end if 

   // Recopilar info de imagenes-----------------------------------------

   aImagesArticulos           := ::imagesProduct( id )

   aStockArticulo             := ::stockProduct( id )

   // Rellenamos el Hash-------------------------------------------------

   aAdd( ::aProducts, { "id"                    => id,;
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

Return ( Self )

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

   local aImgToken      := {}
   local cImgToken      := ""
   local cImagen
   local aImages        := {}
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

METHOD truncateTable( cTable )   

   if TMSCommand():New( ::oConexionMySQLDatabase() ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( cTable ) )
      ::writeText( 'Tabla ' + ::cPreFixtable( cTable ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( cTable ), 3  )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD truncteAllTables() CLASS TComercioProduct

   local tableToDelete
   local tablesToDelete := {  "tax",;
                              "tax_lang",;
                              "tax_rule",;
                              "tax_rules_group",;
                              "tax_rules_group_shop",;
                              "manufacturer",;
                              "manufacturer_shop",;
                              "manufacturer_lang",;
                              "category",;
                              "category_lang",;
                              "category_product",;
                              "category_group",;
                              "category_shop",;
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

   // Vaciamos las tablas de tipos de Iva-----------------------------------------

   for each tableToDelete in tablesToDelete
      ::truncateTable( tableToDelete )
   next 

   // Cargamos la categoría raiz de la que colgarán todas las demás---------------

   // ::insertRootCategory()

   // Limpiamos las referencias de las tablas de gestool--------------------------

   // ::buildCleanPrestashop()

Return ( self )

//---------------------------------------------------------------------------//
// Insertamos el root en la tabla de categorias------------------------------

METHOD insertRootCategory() CLASS TComercioProduct

   local cCommand := ""

   ::writeText( "Añadiendo categoría raiz" )

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category" ) + " ( id_category, id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position ) " + ;
                     "VALUES ( '1', '0', '1', '0', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0' ) "

   if ::commandExecDirect( cCommand )
      ::nNumeroCategorias++
      ::writeText( "He insertado correctamente en la tabla categorías la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) " + ;
                     "VALUES ( '1', '" + str( ::getLanguage() ) + "', 'Root', 'Root', 'Root', '', '', '' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '1', '1', '0' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '1' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '2' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '3' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría root en category_group", 3 )
   end if

   // Metemos la categoría de inicio de la que colgarán los grupos y las categorias

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category" ) + " ( id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position, is_root_category ) VALUES ( '1', '1', '1', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0', '1' ) "

   if ::commandExecDirect( cCommand )
      ::nNumeroCategorias++
      ::writeText( "He insertado correctamente en la tabla categorias la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) VALUES ( '2', '" + str( ::getLanguage() ) + "', 'Inicio', 'Inicio', 'Inicio', '', '', '' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '2', '1', '0' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '1' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '2' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '3' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   SysRefresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD cleanGestoolReferences() CLASS TComercioProduct

   ::writeText( "Limpiamos las referencias de las tablas de tipos de impuestos" )

   ::TPrestashopId():deleteDocumentValuesTax( ::getCurrentWebName() )
   ::TPrestashopId():deleteDocumentValuesTaxRuleGroup( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de fabricantes" )

   ::TPrestashopId():deleteDocumentValuesManufacturer( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de familias" )

   ::TPrestashopId():deleteDocumentValuesCategory( ::getCurrentWebName() )

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

METHOD uploadProductsToPrestashop() CLASS TComercioProduct

   local hProduct
   local nProducts   := len( ::aProducts )

   ::meterProcesoSetTotal( nProducts )
   
   for each hProduct in ::aProducts

      ::meterProcesoText( "Eliminando artículo anterior " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) ) 

      ::deleteProduct( hProduct )

      ::meterProcesoText( "Subiendo artículo " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) ) 

      ::uploadProductToPrestashop( hProduct )
   
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD uploadProductToPrestashop( hProduct ) CLASS TComercioProduct

   local idProduct
   local idCategory

   idCategory           := hGet( hProduct, "id_category_default" )

   ::idCategoryDefault  := ::TPrestashopId():getValueCategory( idCategory, ::getCurrentWebName(), 2 )
   ::idTaxRulesGroup    := ::TPrestashopId():getValueTaxRuleGroup( hGet( hProduct, "id_tax_rules_group" ), ::getCurrentWebName() )
   ::idManufacturer     := ::TPrestashopId():getValueManufacturer( hGet( hProduct, "id_manufacturer" ), ::getCurrentWebName() )

   idProduct            := ::insertProductPrestashopTable( hProduct, idCategory )

   if empty( idProduct )
      Return ( Self )
   end if 

   // Publicar el articulo en su categoria-------------------------------------

   ::insertNodeCategoryProduct( idProduct, idCategory )

   // Publicar el articulo en el root------------------------------------------

   if hGet( hProduct, "lPublicRoot" )
      ::insertNodeCategoryProduct( idProduct, 2 )
   end if

   ::insertProductShop( idProduct, hProduct )

   ::insertProductLang( idProduct, hProduct )

   ::processImageProducts( idProduct, hProduct )

   ::processPropertyProduct( idProduct, hProduct )

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

METHOD insertNodeCategoryProduct( idProduct, idCategory ) CLASS TComercioProduct

   local parentCategory
   local nodeParentCategory

   parentCategory          := ::getParentCategory( idCategory )

   ::insertCategoryProduct( idProduct, parentCategory ) 

   nodeParentCategory      := ::getNodeParentCategory( idCategory )
   if !empty( nodeParentCategory )
      ::insertNodeCategoryProduct( idProduct, nodeParentCategory )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getParentCategory( idCategory ) CLASS TComercioProduct

   local idParentCategory    := 2

   if ::oCategoryDatabase():Seek( idCategory ) .and. ::oCategoryDatabase():lPubInt
      idParentCategory       := ::TPrestashopId():getValueCategory( idCategory, ::getCurrentWebName() )  
   end if

Return ( idParentCategory )

//---------------------------------------------------------------------------//

METHOD getNodeParentCategory( idCategory ) CLASS TComercioProduct

   local idNode            := ""

   if !empty( idCategory ) .and. ::oCategoryDatabase():Seek( idCategory )
      idNode               := ::oCategoryDatabase():cFamCmb
   end if   

Return ( idNode )

//---------------------------------------------------------------------------//

METHOD insertCategoryProduct( idProduct, idCategory ) CLASS TComercioProduct

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

METHOD processImageProducts( idProduct, hProduct ) CLASS TComercioProduct

   local hImage
   local nImagePosition       := 1
   local idImagePrestashop    := 0

   for each hImage in hGet( hProduct, "aImages" )

      idImagePrestashop       := ::insertImage( idProduct, hProduct, hImage, nImagePosition )

      if idImagePrestashop != 0

         ::insertImageLang( hProduct, hImage, idImagePrestashop )

         ::insertImageShop( idProduct, hProduct, hImage, idImagePrestashop )

         // Añadimos la imagen al array para subirla a prestashop--------------

         hSet( hImage, "nTipoImagen", __tipoProducto__ )
         hSet( hImage, "cCarpeta", alltrim( str( idImagePrestashop ) ) )
         hSet( hImage, "cPrefijoNombre", alltrim( str( idImagePrestashop ) ) )
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

            ::insertProductAttributeImage( hProduct, idProperty, ::oPropertyProductDatabase():mImgWeb )

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

METHOD insertProductAttributeImage( hProduct, idProductAttribute, memoImages ) CLASS TComercioProduct

   local cImage
   local aImages
   local cCommand
   local nIdProductImage

   aImages                 := hb_aTokens( memoImages, "," )
   
   if empty( aImages )
      Return ( self )
   end if 

   for each cImage in aImages

      if ::oImageProductDatabase():SeekInOrd( hGet( hProduct, "id" ), "cCodArt" )

         while ::oImageProductDatabase():cCodArt == hGet( hProduct, "id" ) .and. !::oImageProductDatabase():Eof()

            if alltrim( ::oImageProductDatabase():cImgArt ) == alltrim( cImage )

               nIdProductImage   := ::TPrestashopId():getValueImage( hGet( hProduct, "id" ) + str( ::oImageProductDatabase():nId, 10 ), ::getCurrentWebName() )

               cCommand          := "INSERT INTO " + ::cPrefixTable( "product_attribute_image" ) + " ( " + ;
                                       "id_product_attribute, "                                          + ;
                                       "id_image ) "                                                     + ;
                                    "VALUES ( "                                                          + ;
                                       "'" + alltrim( str( idProductAttribute ) ) + "', "                + ;   // id_product_attribute
                                       "'" + alltrim( str( nIdProductImage ) ) + "' )"                         // id_image

               if ::commandExecDirect( cCommand )
                  ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )
               end if

            end if   

            ::oImageProductDatabase():Skip()

         end while   

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

   msgAlert( "uploadImagesToPrestashop()" )

   // Subimos las imagenes de los  artículos-----------------------------------

   ::meterProcesoSetTotal( len( ::aProducts ) )
   
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

   debug( aProductsImages, "uploadImagesToPrestashop()" )

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
