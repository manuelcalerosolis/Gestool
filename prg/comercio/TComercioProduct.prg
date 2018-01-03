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

   DATA  idCategoryDefault  
   DATA  idTaxRulesGroup 
   DATA  idManufacturer

   METHOD isProductInDatabase( idProduct )                         
   METHOD isProductActiveInCurrentWeb()    
   METHOD isProductDeleteInCurrentWeb()                       
   METHOD isProductInIncremental( idProduct ) 

   METHOD buildAllProductInformation()
   METHOD buildProductInformation( idProduct )

      METHOD buildProduct( id )
      METHOD buildDeleteProduct( idProduct, lCleanProducts )
      METHOD buildHashProduct( idProduct, aImagesArticulos, aStockArticulo )      

      METHOD getPrice()
      METHOD getPriceReduction()
      METHOD getPriceReductionTax()                         INLINE ( iif(  ( D():Articulos( ::getView() ) )->lIvaWeb, 1, 0 ) )
      METHOD getDescription()                               INLINE ( iif(  !empty( ( D():Articulos( ::getView() ) )->mDestec ),;
                                                                           alltrim( ( D():Articulos( ::getView() ) )->mDestec ),;
                                                                           alltrim( ( D():Articulos( ::getView() ) )->Nombre ) ) )

      METHOD imagesProduct( id )
      METHOD langsProduct( id )
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

   METHOD insertOneProducts()
      METHOD insertOneProduct( hProduct )

   METHOD deleteProducts()

   METHOD insertProductCategory( idProduct, idCategory )

   METHOD insertAditionalInformation()

   METHOD truncateAllTables() 

   METHOD deleteProduct( hProduct )
   METHOD deleteImages( idProductPrestashop )
   METHOD inactivateProduct( idProduct ) 

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

   METHOD getIdProductImage( id, cImgToken )
   METHOD getDefaultProductImage( id, cImgToken ) 

   METHOD getRootImage( hProductImage )                        INLINE ( cPatTmp() + hget( hProductImage, "cPrefijoNombre" ) + ".jpg" )
   METHOD putFileRootProductImage( hProductImage )

   METHOD getCoverValue( lValue )                              

   METHOD notValidProductId( idProduct )                       INLINE ( empty( idProduct ) .and. !( ::TComercio:lDebugMode ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD buildAllProductInformation() CLASS TComercioProduct

   ::writeText( "Procesando articulos ... " )

   ( D():Articulos( ::getView() ) )->( ordsetfocus( "lWebShop" ) )

   if ( D():Articulos( ::getView() ) )->( dbseek( ::getCurrentWebName() ) )

      while ( alltrim( ( D():Articulos( ::getView() ) )->cWebShop ) == ::getCurrentWebName() ) .and. !( ( D():Articulos( ::getView() ) )->( eof() ) )

         ::buildProductInformation( ( D():Articulos( ::getView() ) )->Codigo )

         ::writeText( "Procesando artículo " + alltrim( ( D():Articulos( ::getView() ) )->Codigo ) + " - " + alltrim( ( D():Articulos( ::getView() ) )->Nombre ) )

         ( D():Articulos( ::getView() ) )->( dbskip() )

      end while

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildProductInformation( idProduct ) CLASS TComercioProduct

   if !( ::isProductInDatabase( idProduct ) )
      RETURN ( .f. )
   end if 

   if !( ::isProductActiveInCurrentWeb( idProduct ) )
      RETURN ( .f. )
   end if 

   // if !( ::isProductInIncremental( idProduct ) )
   //    msgalert( "salida de productos incremental")
   //    RETURN ( .f. )
   // end if 

   ::TComercioTax():buildTaxRuleGroup( ( D():Articulos( ::getView() ) )->TipoIva )

   ::TComercioManufacturer():buildManufacturerProduct( ( D():Articulos( ::getView() ) )->cCodFab )

   ::TComercioCategory():buildCategory( ( D():Articulos( ::getView() ) )->Familia )
   
   ::TComercioProperty():buildPropertyProduct( ( D():Articulos( ::getView() ) )->Codigo )
      
RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isProductInDatabase( idProduct ) CLASS TComercioProduct

   if !( ( D():Articulos( ::getView() ) )->( dbseekinord( idProduct, "Codigo" ) ) )
      ::writeText( "El artículo " + alltrim( idProduct  ) + " no se ha encontrado en la base de datos" )
      RETURN ( .f. )
   end if 

RETURN ( .t. )
                                                                           
//---------------------------------------------------------------------------//

METHOD isProductActiveInCurrentWeb( idProduct ) CLASS TComercioProduct

   if !( ( D():Articulos( ::getView() ) )->lPubInt )
      ::writeText( "Artículo " + alltrim( idProduct ) + " no seleccionado para web" ) 
      RETURN .f.
   end if 

   if ( alltrim( ( D():Articulos( ::getView() ) )->cWebShop ) != ::getCurrentWebName() ) 
      ::writeText( "Artículo " + alltrim( idProduct ) + " no pertence a la web seleccionada" )
      RETURN .f.
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD isProductInIncremental( idProduct ) CLASS TComercioProduct

   if !::TComercio:isIncrementalMode()
      RETURN .f.
   end if 

   if !empty( ::TPrestashopId():getValueProduct( idProduct, ::getCurrentWebName() ) )
      RETURN .f.
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD isProductDeleteInCurrentWeb( idProduct ) CLASS TComercioProduct

   if ( ( D():Articulos( ::getView() ) )->lPubInt )
      ::writeText( "Artículo " + alltrim( idProduct ) + " no eliminado de la web" ) 
      RETURN .f.
   end if 

   if ( alltrim( ( D():Articulos( ::getView() ) )->cWebShop ) != ::getCurrentWebName() ) 
      ::writeText( "Artículo " + alltrim( idProduct ) + " no pertence a la web seleccionada" )
      RETURN .f.
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD buildProduct( idProduct, lCleanProducts ) CLASS TComercioProduct

   local aStockArticulo       := {}
   local aImagesArticulos     := {}
   local aLangsArticulos      := {}

   DEFAULT lCleanProducts     := .f.

   if lCleanProducts
      ::aProducts             := {}
   else
      if aScan( ::aProducts, {|h| hGet( h, "id" ) == idProduct } ) != 0
         RETURN ( .f. )
      end if 
   end if 

   if !( ::isProductInDatabase( idProduct ) )
      RETURN ( .f. )
   end if 

   if !( ::isProductActiveInCurrentWeb( idProduct ) )
      RETURN ( .f. )
   end if 

   // Recopilar info del stock-------------------------------------------------

   aStockArticulo             := ::stockProduct( idProduct )

   if !( ::TComercioConfig():isProcessWithoutStock() ) .and. ::isTotalStockZero( aStockArticulo )
      ::writeText( "El artículo " + alltrim( idProduct ) + " no tiene stock en el almacen de la web")
      RETURN ( .f. )
   end if 

   // Recopilar info de imagenes-----------------------------------------" )

   aImagesArticulos           := ::imagesProduct( idProduct )
   if !( ::TComercioConfig():isProcessWithoutImage() ) .and. empty( aImagesArticulos ) 
      ::writeText( "El artículo " + alltrim( idProduct ) + " no tiene imagenes")
      RETURN ( .f. )
   end if 

   // Recopilar idiomas de los productos--------------------------------------

   aLangsArticulos            := ::langsProduct( idProduct )

   // Contruimos el hash con toda la informacion del producto------------------

   ::buildHashProduct( idProduct, aImagesArticulos, aStockArticulo, aLangsArticulos )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildDeleteProduct( idProduct, lCleanProducts ) CLASS TComercioProduct

   DEFAULT lCleanProducts     := .f.

   if lCleanProducts
      ::aProducts             := {}
   else
      if aScan( ::aProducts, {|h| hGet( h, "id" ) == idProduct } ) != 0
         RETURN ( .f. )
      end if 
   end if 

   if !( ::isProductInDatabase( idProduct ) )
      RETURN ( .f. )
   end if 

   if !( ::isProductDeleteInCurrentWeb( idProduct ) )
      RETURN ( .f. )
   end if 

   ::buildHashProduct( idProduct )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildHashProduct( idProduct, aImagesArticulos, aStockArticulo, aLangsArticulos ) CLASS TComercioProduct

   DEFAULT aImagesArticulos   := {}
   DEFAULT aStockArticulo     := {}
   DEFAULT aLangsArticulos    := {}
   
   // Rellenamos el Hash-------------------------------------------------

   aAdd( ::aProducts,   {  "id"                    => idProduct,;
                           "name"                  => alltrim( ( D():Articulos( ::getView() ) )->Nombre ),;
                           "id_manufacturer"       => ( D():Articulos( ::getView() ) )->cCodFab ,;
                           "id_tax_rules_group"    => ( D():Articulos( ::getView() ) )->TipoIva ,;
                           "id_category_default"   => ( D():Articulos( ::getView() ) )->Familia ,;
                           "reference"             => ( D():Articulos( ::getView() ) )->Codigo ,;
                           "weight"                => ( D():Articulos( ::getView() ) )->nPesoKg ,;
                           "specific_price"        => ( D():Articulos( ::getView() ) )->lSbrInt,;
                           "description_short"     => alltrim( ( D():Articulos( ::getView() ) )->Nombre ) ,;
                           "meta_title"            => alltrim( ( D():Articulos( ::getView() ) )->cTitSeo ) ,;
                           "meta_description"      => alltrim( ( D():Articulos( ::getView() ) )->cDesSeo ) ,;
                           "meta_keywords"         => alltrim( ( D():Articulos( ::getView() ) )->cKeySeo ) ,;
                           "lPublicRoot"           => ( D():Articulos( ::getView() ) )->lPubPor,;
                           "cImagen"               => alltrim( ( D():Articulos( ::getView() ) )->cImagen ),;
                           "link_rewrite"          => cLinkRewrite( ( D():Articulos( ::getView() ) )->Nombre ),;
                           "price"                 => ::getPrice(),;
                           "reduction"             => ::getPriceReduction(),;
                           "reduction_tax"         => ::getPriceReductionTax(),;
                           "description"           => ::getDescription(),; 
                           "aImages"               => aImagesArticulos,;
                           "aStock"                => aStockArticulo,;
                           "aLangs"                => aLangsArticulos } )

RETURN ( ::aProducts )

//---------------------------------------------------------------------------//


METHOD getPrice() CLASS TComercioProduct

   local priceProduct      := 0

   // calcula el precio en funcion del descuento-------------------------------

   if ( D():Articulos( ::getView() ) )->lSbrInt .and. ( D():Articulos( ::getView() ) )->pVtaWeb != 0

      priceProduct         := ( D():Articulos( ::getView() ) )->pVtaWeb

   else

      if ( D():Articulos( ::getView() ) )->lIvaWeb
         priceProduct      := round( ( D():Articulos( ::getView() ) )->nImpIva1 / ( ( nIva( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) / 100 ) + 1 ), 6 )
      else
         priceProduct      := ( D():Articulos( ::getView() ) )->nImpInt1
      end if

   end if 

RETURN ( priceProduct )

//---------------------------------------------------------------------------//
//
// calcula la reduccion sobre el precio
//

METHOD getPriceReduction() CLASS TComercioProduct

   local priceReduction    := 0

   if ( D():Articulos( ::getView() ) )->lSbrInt .and. ( D():Articulos( ::getView() ) )->pVtaWeb != 0

      if ( D():Articulos( ::getView() ) )->lIvaWeb
         priceReduction    := ( D():Articulos( ::getView() ) )->pVtaWeb
         priceReduction    += ( D():Articulos( ::getView() ) )->pVtaWeb * nIva( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) / 100
         priceReduction    -= ( D():Articulos( ::getView() ) )->nImpIva1 
      else
         priceReduction    := ( D():Articulos( ::getView() ) )->pVtaWeb 
         priceReduction    -= ( D():Articulos( ::getView() ) )->nImpInt1
      end if

   end if 

RETURN ( priceReduction )

//---------------------------------------------------------------------------//

METHOD imagesProduct( idProduct ) CLASS TComercioProduct

   local nDefault       := 0
   local cImagen
   local aImages        := {}
   local cImgToken      := ""
   local aImgToken      := {}
   local nOrdAntImg
   local nOrdAntDiv     

   // Pasamos las imígenes de los artículos por propiedades-----------------------" )

   nOrdAntDiv           := ( D():ArticuloPrecioPropiedades( ::getView() ) )->( ordsetfocus( "cCodigo" ) )

   if ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbseek( idProduct ) )

      while ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodArt == idProduct .and. !( D():ArticuloPrecioPropiedades( ::getView() ) )->( eof() )

         if !empty( ( D():ArticuloPrecioPropiedades( ::getView() ) )->mImgWeb )

            aImgToken   := hb_atokens( ( D():ArticuloPrecioPropiedades( ::getView() ) )->mImgWeb, "," )

            for each cImgToken in aImgToken

               if file( cFileBmpName( cImgToken ) ) .and. ascan( aImages, {|a| hGet( a, "name" ) == cImgToken } ) == 0

                  if ::getDefaultProductImage( idProduct, cImgToken )
                     nDefault++
                  end if

                  aadd( aImages, {  "name"               => cFileBmpName( cImgToken ),;
                                    "idProductGestool"   => idProduct,;
                                    "id"                 => ::getIdProductImage( idProduct, cImgToken ),;
                                    "lDefault"           => if( nDefault > 0, .f., ::getDefaultProductImage( idProduct, cImgToken ) ) } )
               end if 

            next

         end if

         ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbskip() )

      end while

   end if

   ( D():ArticuloPrecioPropiedades( ::getView() ) )->( ordsetfocus( nOrdAntDiv ) )

   // Pasamos las imígenes de la tabla de artículos-------------------------------" )

   if empty( aImages )

      nOrdAntImg     := ( D():ArticuloImagenes( ::getView() ) )->( ordsetfocus( "cCodArt" ) )

      if ( D():ArticuloImagenes( ::getView() ) )->( dbseek( idProduct ) )

         while ( D():ArticuloImagenes( ::getView() ) )->cCodArt == idProduct .and. ( D():ArticuloImagenes( ::getView() ) )->( !eof() ) 

            cImagen  := alltrim( ( D():ArticuloImagenes( ::getView() ) )->cImgArt )

            if file( cFileBmpName( cImagen ) ) .and. ascan( aImages, {|a| hGet( a, "name" ) == cImagen } ) == 0

               if ( D():ArticuloImagenes( ::getView() ) )->lDefImg
                  nDefault++
               end if

               aadd( aImages, {  "name"               => cFileBmpName( cImagen ),;
                                 "idProductGestool"   => idProduct,;
                                 "id"                 => ( D():ArticuloImagenes( ::getView() ) )->nId,;
                                 "lDefault"           => if( nDefault > 0, .f., ( D():ArticuloImagenes( ::getView() ) )->lDefImg ) } )
            end if 

            ( D():ArticuloImagenes( ::getView() ) )->( dbskip() ) 

         end while

      end if 

      ( D():ArticuloImagenes( ::getView() ) )->( ordsetfocus( nOrdAntImg ) )

   end if

   // Nos aseguramos de que por lo menos una imígen sea por defecto------------" )

   if !empty( aImages ) .and. ascan( aImages, {|a| hGet( a, "lDefault" ) == .t. } ) == 0
      hSet( aImages[ 1 ], "lDefault", .t. )
   end if   

RETURN ( aImages )

//---------------------------------------------------------------------------//

METHOD langsProduct( idProduct ) CLASS TComercioProduct

   local idLang
   local aLangs         := {}
   local nOrdenAnterior        

   // Pasamos las imígenes de los artículos por propiedades-----------------------

   nOrdenAnterior       := ( D():ArticuloLenguaje( ::getView() ) )->( ordsetfocus( "cCodArt" ) )

   if ( D():ArticuloLenguaje( ::getView() ) )->( dbseek( idProduct ) )

      while ( D():ArticuloLenguaje( ::getView() ) )->cCodArt == idProduct .and. !( D():ArticuloLenguaje( ::getView() ) )->( eof() )

         idLang         := ::TComercioConfig():getLang( ( D():ArticuloLenguaje( ::getView() ) )->cCodLen )

         if !empty( idLang )
            aadd( aLangs,  {  "idLang"             => idLang,;
                              "shortDescription"   => ( D():ArticuloLenguaje( ::getView() ) )->cDesTik,;
                              "longDescription"    => ( D():ArticuloLenguaje( ::getView() ) )->cDesArt } )
         end if 

         ( D():ArticuloLenguaje( ::getView() ) )->( dbskip() )

      end while

   end if

   ( D():ArticuloLenguaje( ::getView() ) )->( ordsetfocus( nOrdenAnterior ) )

RETURN ( aLangs )

//---------------------------------------------------------------------------//

METHOD stockProduct( id ) CLASS TComercioProduct
   
   local sStock
   local nStock            := 0
   local aStockProduct     := {}
   local aStockArticulo    := ::oStock():aStockArticulo( id, ::TComercioConfig():getStore() )
   local lApunteResumen    := .t.

   for each sStock in aStockArticulo

      if sStock:nUnidades > 0

         lApunteResumen    := (  AllTrim( sStock:cCodigoPropiedad1 ) != "" .or.;
                                 AllTrim( sStock:cCodigoPropiedad2 ) != "" .or.;
                                 AllTrim( sStock:cValorPropiedad1 ) != "" .or.;
                                 AllTrim( sStock:cValorPropiedad2 ) != "" )

         if dbSeekInOrd( id + sStock:cCodigoPropiedad1 + sStock:cCodigoPropiedad2 + sStock:cValorPropiedad1 + sStock:cValorPropiedad2, "cCodArt", D():ArticuloPrecioPropiedades( ::getView() ) ) .or.;
            ( AllTrim( sStock:cCodigoPropiedad1 ) == "" .and. AllTrim( sStock:cCodigoPropiedad2 ) == "" .and. AllTrim( sStock:cValorPropiedad1 ) == "" .and. AllTrim( sStock:cValorPropiedad2 ) == "" )

            aAdd( aStockProduct, {  "idProduct"             => id ,;
                                    "idFirstProperty"       => sStock:cCodigoPropiedad1 ,;
                                    "idSecondProperty"      => sStock:cCodigoPropiedad2 ,;
                                    "valueFirstProperty"    => sStock:cValorPropiedad1 ,;
                                    "valueSecondProperty"   => sStock:cValorPropiedad2 ,;
                                    "unitStock"             => sStock:nUnidades } )

         end if

         nStock            += sStock:nUnidades

      end if 

   next

   // apunte resumen ---------------------------------------------------------

   if lApunteResumen

      aAdd( aStockProduct, {  "idProduct"             => id ,;
                              "idFirstProperty"       => space( 20 ) ,;
                              "idSecondProperty"      => space( 20 ) ,;
                              "valueFirstProperty"    => space( 20 ) ,;
                              "valueSecondProperty"   => space( 20 ) ,;
                              "unitStock"             => nStock } )

   end if

RETURN ( aStockProduct )

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
                              "stock_available" }

   for each tableToDelete in tablesToDelete
      ::truncateTable( tableToDelete )
   next 

RETURN ( self )

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

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Subimos los artículos
//

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertOneProducts() CLASS TComercioProduct

   aeval( ::aProducts, {|hProduct| ::deleteProduct( hProduct ), ::insertOneProduct( hProduct ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteProducts() CLASS TComercioProduct

   local hProduct
   local nProducts   := len( ::aProducts )

   ::meterProcesoSetTotal( nProducts )
   
   for each hProduct in ::aProducts

      ::meterProcesoText( "Eliminando artículo anterior " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) ) 

      ::deleteProduct( hProduct )
   
   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertProduct( hProduct ) CLASS TComercioProduct

   local idProduct

   ::idCategoryDefault  := ::TPrestashopId():getValueCategory( hGet( hProduct, "id_category_default" ), ::getCurrentWebName(), 2 )

   ::idTaxRulesGroup    := ::TPrestashopId():getValueTaxRuleGroup( hGet( hProduct, "id_tax_rules_group" ), ::getCurrentWebName() )

   ::idManufacturer     := ::TPrestashopId():getValueManufacturer( hGet( hProduct, "id_manufacturer" ), ::getCurrentWebName() )

   // Publicar el articulo en su categoria-------------------------------------

   idProduct               := ::insertProductPrestashopTable( hProduct, hGet( hProduct, "id_category_default" ) )

   if ::notValidProductId( idProduct )
      RETURN ( Self )
   end if 

   ::insertNodeProductCategory( idProduct, hGet( hProduct, "id_category_default" ) )

   // Publicar el articulo en el root------------------------------------------

   if hGet( hProduct, "lPublicRoot" )
      ::insertNodeProductCategory( idProduct, 2 )
   end if

   ::insertProductShop( idProduct, hProduct )

   ::insertProductLang( idProduct, hProduct )

   ::processImageProducts( idProduct, hProduct )

   ::TComercioProperty():processPropertyProduct( idProduct, hProduct )

   ::insertReduction( idProduct, hProduct )

   ::processStockProduct( idProduct, hProduct )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertOneProduct( hProduct ) CLASS TComercioProduct

   local idProduct

   ::idCategoryDefault  := ::TComercioCategory():getOrBuildCategory( hGet( hProduct, "id_category_default" ) ) 

   ::idTaxRulesGroup    := ::TComercioTax():getOrBuildTaxRulesGroup( hGet( hProduct, "id_tax_rules_group" ) )

   ::idManufacturer     := ::TComercioManufacturer():getOrBuildManufacturerProduct( hGet( hProduct, "id_manufacturer" ) )

   ::TComercioProperty():getOrBuildProperties( hGet( hProduct, "id") )

   // Publicar el articulo en su categoria-------------------------------------

   idProduct            := ::insertProductPrestashopTable( hProduct, hGet( hProduct, "id_category_default" ) )

   if ::notValidProductId( idProduct )
      RETURN ( Self )
   end if 

   ::insertNodeProductCategory( idProduct, hGet( hProduct, "id_category_default" ) )

   // Publicar el articulo en el root------------------------------------------

   if hGet( hProduct, "lPublicRoot" )
      ::insertNodeProductCategory( idProduct, 2 )
   end if

   ::insertProductShop( idProduct, hProduct )

   ::insertProductLang( idProduct, hProduct )

   ::processImageProducts( idProduct, hProduct )

   ::TComercioProperty():processPropertyProduct( idProduct, hProduct )

   ::insertReduction( idProduct, hProduct )

   ::processStockProduct( idProduct, hProduct )

   if len( ::TComercioCategory():aCategoriesProduct ) != 0
      ::TComercioCategory():recalculatePositionsCategory()
   end if

   ::TComercioCategory():insertTopMenuPs()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertProductPrestashopTable( hProduct, idCategory ) CLASS TComercioProduct

   local cCommand
   local idProduct

   ::writeText( "Añadiendo artículo: " + hGet( hProduct, "description" ) )

   idProduct         := 0

   cCommand          := "INSERT IGNORE INTO " + ::cPrefixTable( "product" ) + " ( " + ;
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

      RETURN ( idProduct )

   end if

RETURN ( idProduct )

//---------------------------------------------------------------------------//

METHOD insertProductShop( idProduct, hProduct ) CLASS TComercioProduct

   local cCommand

   cCommand    := "INSERT IGNORE INTO " + ::cPrefixTable( "product_shop" ) + " ( " +;
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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD insertProductLang( idProduct, hProduct ) CLASS TComercioProduct

   local hLang
   local cCommand

   cCommand    := "INSERT IGNORE INTO " + ::cPrefixTable( "product_lang" ) + " ( " +;
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
                     ::getLanguage() + ", " + ;                                                                // id_lang
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "description" ) ) + "', " + ; // description
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "description_short" ) ) + "', " + ;                                   // description_short
                     "'" + hGet( hProduct, "link_rewrite" ) + "', " + ;                                        // link_rewrite
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "meta_title" ) ) + "', " + ;                                          // Meta_título
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "meta_description" ) ) + "', " + ;                                    // Meta_description
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "meta_keywords" ) ) + "', " + ;                                       // Meta_keywords
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "name" ) ) + "', " + ;                                                // name
                     "'En stock', " + ;                                                                        // avatible_now
                     "'' )"

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   end if

   for each hLang in hGet( hProduct, "aLangs" )

      cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "product_lang" ) + " ( " +;
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
                     "'" + alltrim( str( idProduct ) ) + "', " + ;                                                // id_product
                     hget( hLang, "idLang" ) + ", " + ;                                                           // id_lang
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hLang, "longDescription" ) ) + "', " + ;   // description
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hLang, "shortDescription" ) ) + "', " + ;                                          // description_short
                     "'" + hGet( hProduct, "link_rewrite" ) + "', " + ;                                           // link_rewrite
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "meta_title" ) ) + "', " + ;                                             // Meta_título
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "meta_description" ) ) + "', " + ;                                       // Meta_description
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "meta_keywords" ) ) + "', " + ;                                          // Meta_keywords
                     "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "name" ) ) + "', " + ;                                                   // name
                     "'En stock', " + ;                                                                           // avatible_now
                     "'' )"

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
      end if

   next 

   SysRefresh()

RETURN ( self )

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

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertProductCategory( idProduct, idCategory ) CLASS TComercioProduct

   local cCommand

   cCommand       := "DELETE FROM " + ::cPrefixTable( "category_product" )             + " " + ;
                     "WHERE id_category = " + alltrim( str( max( idCategory, 1 ) ) )   + " " + ;
                     "AND id_product = " + alltrim( str( idProduct ) )

   ::commandExecDirect( cCommand )

   cCommand       := "INSERT IGNORE INTO " + ::cPrefixTable( "category_product" ) + " ( " + ;
                        "id_category, " + ;
                        "id_product ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( max( idCategory, 1 ) ) ) + "', " + ;
                        "'" + alltrim( str( idProduct ) ) + "' )"

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + str( idProduct ) + " en la tabla " + ::cPrefixTable( "category_product" ), 3 )
      RETURN ( .f. )
   end if

   SysRefresh()

RETURN ( .t. )

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

         // Aíadimos la imagen al array para subirla a prestashop--------------

         hSet( hImage, "nTipoImagen", __tipoProducto__ )
         hSet( hImage, "cCarpeta", alltrim( str( idImagePrestashop ) ) )
         hSet( hImage, "cPrefijoNombre", alltrim( str( idImagePrestashop ) ) )
         hSet( hImage, "aTypeImages", {} )
         hSet( hImage, "aRemoteImages", {} )

      end if 

      nImagePosition++

   next

RETURN .t.

//---------------------------------------------------------------------------//

METHOD insertImage( idProduct, hProduct, hImage, nImagePosition )

   local cCommand
   local idImagePrestashop    := 0

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "image" ) + " ( " +;
                  "id_product, " + ;
                  "position, " + ;
                  "cover ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( idProduct ) ) + "', " + ;
                  "'" + alltrim( str( nImagePosition ) ) + "', " + ;
                  ::getCoverValue( hGet( hImage, "lDefault" ) ) + " )"

   if ::commandExecDirect( cCommand )
      idImagePrestashop       := ::oConexionMySQLDatabase():GetInsertId()
      ::writeText( "Insertada la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image" ), 3 )
   end if

   if !empty( idImagePrestashop )
      ::TPrestashopId():setValueImage( hGet( hProduct, "id" ) + str( hGet( hImage, "id" ), 10 ), ::getCurrentWebName(), idImagePrestashop )
   end if

RETURN ( idImagePrestashop )

//---------------------------------------------------------------------------//

METHOD insertImageLang( hProduct, hImage, idImagePrestashop )

   local cCommand

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "image_lang" ) + " ( "                             + ;
                  "id_image, "                                                                     + ;
                  "id_lang, "                                                                      + ;
                  "legend ) "                                                                      + ;
               "VALUES ("                                                                          + ;
                  "'" + alltrim( str( idImagePrestashop ) ) + "', "                                + ;
                  ::getLanguage() + ", "                                                           + ;
                  "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hProduct, "name" ) ) + "' )"

   if ::commandExecDirect( cCommand )
      ::writeText( "Insertada la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD insertImageShop( idProduct, hProduct, hImage, idImagePrestashop )

   local cCommand 

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "image_shop" ) + " ( "                                + ;
                  if( ::lProductIdColumnImageShop(), "id_product, ", "" )                             + ;
                  "id_image, "                                                                        + ;
                  "id_shop, "                                                                         + ;
                  "cover ) "                                                                          + ;
               "VALUES ( "                                                                            + ;
                  if( ::lProductIdColumnImageShop(), "'" + alltrim( str( idProduct ) ) + "', ", "" )  + ;   // id_product
                  "'" + alltrim( str( idImagePrestashop ) ) + "', "                                   + ;   // id_image
                  "'1', "                                                                             + ;   // id_shop
                  ::getCoverValue( hGet( hImage, "lDefault" ) ) + " )"                                      // cover

   if ::commandExecDirect( cCommand )
      ::writeText( "Insertada la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image_shop" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image_shop" ), 3 )
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD deleteProduct( hProduct ) CLASS TComercioProduct

   local oQuery
   local oQuery2
   local cCommand                      
   local idDelete                      := 0
   local idDelete2                     := 0
   local idProductGestool              := hget( hProduct, "id" )
   local idProductPrestashop 

   idProductPrestashop                 := alltrim( str( ::TPrestashopId():getValueProduct( idProductGestool, ::getCurrentWebName() ) ) )
   if empty( idProductPrestashop )
      RETURN ( Self )
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

   // Eliminamos las imígenes del artículo---------------------------------------

   ::writeText( "Eliminando imígenes de prestashop" )

   ::deleteImages( idProductPrestashop )

   // Quitamos la referencia de nuestra tabla-------------------------------------

   ::writeText( "Eliminando referencias en gestool" )

   ::TPrestashopId():deleteDocumentValuesProduct( idProductGestool, ::getCurrentWebName() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD inactivateProduct( idProduct ) CLASS TComercioProduct

   local cCommand
   local idProductPrestashop 

   idProductPrestashop  := alltrim( str( ::TPrestashopId():getValueProduct( idProduct, ::getCurrentWebName() ) ) )

   if empty( idProductPrestashop )
      RETURN ( Self )
   end if

   ::writeText( "Desactivando artículo " + alltrim( idProduct ) + " de prestashop" )

   cCommand             := "UPDATE " + ::cPrefixTable( "product" ) + ;
                              " SET active = 0, indexed = 0" + ;
                              " WHERE id_product = '" + idProductPrestashop + "'"

   // ::commandExecDirect( cCommand )

   ::addMegaCommand( cCommand )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteImages( idProductPrestashop ) CLASS TComercioProduct

   local idDelete
   local oQuery
   local cCommand    := ""

   if empty( idProductPrestashop )
      RETURN ( Self )   
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

RETURN nil

//---------------------------------------------------------------------------//

METHOD uploadImagesToPrestashop() CLASS TComercioProduct

   local hProduct
   local nProducts   := len( ::aProducts )

   ::meterProcesoSetTotal( nProducts )

   for each hProduct in ::aProducts

      ::uploadImageToPrestashop( hProduct )

      ::meterProcesoText( "Subiendo imagenes " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) )
   
   next

   sysrefresh()

RETURN ( Self )

//---------------------------------------------------------------------------//
// Subimos los ficheros de imagenes

METHOD uploadImageToPrestashop( hProduct ) CLASS TComercioProduct

   local cTypeImage
   local hProductImage
   local aProductsImages   := hGet( hProduct, "aImages" )

   if empty( aProductsImages )
      RETURN ( nil )
   end if 

   CursorWait()

   ::meterProcesoSetTotal( len( aProductsImages ) )

   for each hProductImage in aProductsImages

      ::buildFilesProductImages( hProductImage )

      ::ftpUploadFilesProductImages( hProductImage )

      ::putFileRootProductImage( hProductImage )

   next

   CursorWe()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildFilesProductImages( hProductImage ) CLASS TComercioProduct

   local rootImage
   local fileImage         
   local oTipoImage

   if !hhaskey( hProductImage, "cPrefijoNombre" )  .or.;
      !hhaskey( hProductImage, "nTipoImagen" )     .or.;
      !hhaskey( hProductImage, "aTypeImages" )     

      RETURN ( nil )

   end if 

   CursorWait()

   rootImage               := ::getRootImage( hProductImage )

   ::meterProcesoText( "Root imagen obtenida : " + rootImage )

   saveImage( hget( hProductImage, "name" ), rootImage )

   ::meterProcesoText( "Imagen : " + hget( hProductImage, "name" ) + ", guardada como : " + rootImage )

   aadd( hget( hProductImage, "aTypeImages" ), rootImage )

   for each oTipoImage in ::aTypeImagesPrestashop()

      if hget( hProductImage, "nTipoImagen" ) == __tipoProducto__ .and. oTipoImage:lProducts

         fileImage         := cPatTmp() + hget( hProductImage, "cPrefijoNombre" ) + "-" + oTipoImage:cNombreTipo + ".jpg"

         saveImage( rootImage, fileImage, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

         aadd( hget( hProductImage, "aTypeImages" ), fileImage )

         SysRefresh()

      end if 

   next

   CursorWe()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ftpUploadFilesProductImages( hProductImage ) CLASS TComercioProduct

   local cTypeImage
   local cRemoteImage

   if !hhaskey( hProductImage, "aTypeImages")
      RETURN ( nil )
   end if 

   for each cTypeImage in hget( hProductImage, "aTypeImages" )

      ::meterProcesoText( "Subiendo imagen " + cTypeImage + " en directorio " + ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) )

      ::oFtp():CreateFile( cTypeImage, ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) )

      cRemoteImage      := "http://" + ::TComercioConfig():getMySqlServer() + "/" + ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) + cNoPath( cTypeImage ) 

      aadd( hget( hProductImage, "aRemoteImages" ), cRemoteImage )

      SysRefresh()

      ferase( cTypeImage )

      SysRefresh()

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertAditionalInformation() CLASS TComercioProduct

   ::TComercioTax():insertTaxesPrestashop()

   ::TComercioManufacturer():insertManufacturersPrestashop()

   ::TComercioProperty():insertPropertiesPrestashop()
 
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getTotalStock( aStock ) CLASS TComercioProduct

   local hStock
   local nTotalStock := 0

   for each hStock in aStock
      nTotalStock    += hGet( hStock, "unitStock" )
   next 

RETURN ( nTotalStock )

//---------------------------------------------------------------------------//

METHOD insertReduction( idProduct, hProduct ) CLASS TComercioProduct

   local cCommand       := ""

   if hGet( hProduct, "specific_price" ) .and. hGet( hProduct, "reduction" ) != 0

      cCommand          := "INSERT IGNORE INTO " + ::cPrefixTable( "specific_price" ) + " ( " + ; 
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
                              "'0', " + ;                                                                                                           // id_specific_price_rule
                              "'0', " + ;                                                                                                           // id_cart
                              "'" + alltrim( str( idProduct ) ) + "', " + ;                                                                         // id_product
                              "'1', " + ;                                                                                                           // id_shop
                              "'0', " + ;                                                                                                           // id_shop_group
                              "'0', " + ;                                                                                                           // id_currency
                              "'0', " + ;                                                                                                           // id_country
                              "'0', " + ;                                                                                                           // id_group
                              "'0', " + ;                                                                                                           // id_customer
                              "'0', " + ;                                                                                                           // id_product_attribute
                              "'-1', " + ;                                                                                                          // price
                              "'1', " + ;                                                                                                           // from_quantity
                              "'" + alltrim( str( hGet( hProduct, "reduction" ) ) ) + "', " + ;                                                     // reduction
                              if( ::lSpecificPriceIdColumnReductionTax, "'" + alltrim( str( hGet( hProduct, "reduction_tax" ) ) ) + "', ", "" ) + ; // reduction_tax
                              "'amount' )"                                                                                                          // reduction_type
   
      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar una oferta de " + hGet( hProduct, "name" ), 3 )
      end if

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processStockProduct( idProduct, hProduct ) CLASS TComercioProduct

   local hStock
   local cCommand
   local idProductPrestashop     

   idProductPrestashop           := ::TPrestashopId():getValueProduct( hget( hProduct, "id" ), ::getCurrentWebName() )

   cCommand                      := "DELETE FROM " + ::cPrefixTable( "stock_available" ) + " "                          + ;
                                       "WHERE id_product = " + alltrim( str( idProductPrestashop ) ) 

   ::commandExecDirect( cCommand )

   for each hStock in hGet( hProduct, "aStock" )

      ::insertStockProduct( idProductPrestashop, hStock )

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertStockProduct( idProductPrestashop, hStock ) CLASS TComercioProduct

   local cText
   local cCommand
   local unitStock               
   local attributeFirstProperty  
   local attributeSecondProperty 
   local idProductAttribute      := 0
   local isStockByProperty       := .f.

   isStockByProperty             := !empty( hget( hStock, "idFirstProperty" ) )     .or.;
                                    !empty( hget( hStock, "valueFirstProperty" ) )  .or.;
                                    !empty( hget( hStock, "idSecondProperty" ) )    .or.;
                                    !empty( hget( hStock, "valueSecondProperty" ) )

   attributeFirstProperty        := ::TPrestashopId():getValueAttribute( hget( hStock, "idFirstProperty" ) + hget( hStock, "valueFirstProperty" ),     ::getCurrentWebName() )
   attributeSecondProperty       := ::TPrestashopId():getValueAttribute( hget( hStock, "idSecondProperty" ) + hget( hStock, "valueSecondProperty" ),   ::getCurrentWebName() ) 

   unitStock                     := hget( hStock, "unitStock" )

   if ( attributeFirstProperty != 0 ) .or. ( attributeSecondProperty != 0 )

      idProductAttribute         := ::getProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty )

   end if   

      //if idProductAttribute != 0

         cCommand                      := "INSERT IGNORE INTO " + ::cPrefixTable( "stock_available" ) + " ( "                        + ;
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

      /*end if

   else

         cCommand                      := "INSERT IGNORE INTO " + ::cPrefixTable( "stock_available" ) + " ( "                        + ;
                                             "id_product, "                                                                   + ;
                                             "id_product_attribute, "                                                         + ;
                                             "id_shop, "                                                                      + ;
                                             "id_shop_group, "                                                                + ;
                                             "quantity, "                                                                     + ;
                                             "depends_on_stock, "                                                             + ;
                                             "out_of_stock ) "                                                                + ;
                                          "VALUES ( "                                                                         + ;
                                             "'" + alltrim( str( idProductPrestashop ) ) + "', "                              + ;
                                             "'0', "                                                                          + ;   
                                             "'1', "                                                                          + ;
                                             "'0', "                                                                          + ;
                                             "'" + alltrim( str( unitStock ) ) + "', "                                        + ;
                                             "'0', "                                                                          + ;
                                             "'2' )"

         ::commandExecDirect( cCommand )
   
   end if*/

   ::writeText(   "Actualizando stock con propiedades : " + alltrim( str( attributeFirstProperty ) ) + " , " + ;
                  alltrim( str( attributeSecondProperty ) ) + ", " + ;
                  "cantidad : " + alltrim( str( unitStock ) ) )

RETURN .t.   

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

RETURN ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD getIdProductImage( id, cImgToken ) CLASS TComercioProduct

   if ( D():ArticuloImagenes( ::getView() ) )->( dbseek( id ) )

      while ( D():ArticuloImagenes( ::getView() ) )->cCodArt == id .and. ( D():ArticuloImagenes( ::getView() ) )->( !eof() ) 

         if alltrim( ( D():ArticuloImagenes( ::getView() ) )->cImgArt ) == alltrim( cImgToken )
            RETURN ( ( D():ArticuloImagenes( ::getView() ) )->nId )
         end if 

         ( D():ArticuloImagenes( ::getView() ) )->( dbskip() )

      end while 

   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD getDefaultProductImage( id, cImgToken ) CLASS TComercioProduct

   if ( D():ArticuloImagenes( ::getView() ) )->( dbseek( id ) )

      while ( D():ArticuloImagenes( ::getView() ) )->cCodArt == id .and. ( D():ArticuloImagenes( ::getView() ) )->( !eof() ) 

         if alltrim( ( D():ArticuloImagenes( ::getView() ) )->cImgArt ) == alltrim( cImgToken )
            RETURN ( ( D():ArticuloImagenes( ::getView() ) )->lDefImg )
         end if 

         ( D():ArticuloImagenes( ::getView() ) )->( dbskip() )

      end while 

   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD putFileRootProductImage( hProductImage ) CLASS TComercioProduct

   local rootImage      
   local cNameImage        
   local aRemoteImages     
   local idProductGestool  

   if hhaskey( hProductImage, "name" )
      cNameImage        := hget( hProductImage, "name" )
   end if

   if hhaskey( hProductImage, "aRemoteImages" )
      aRemoteImages     := hget( hProductImage, "aRemoteImages" )
   end if

   if hhaskey( hProductImage, "idProductGestool" )
      idProductGestool  := hget( hProductImage, "idProductGestool" )
   end if

   if empty( cNameImage )
      RETURN .f.
   end if 

   if empty( aRemoteImages ) 
      RETURN .f.
   end if 

   if empty( idProductGestool )
      RETURN .f.
   end if 

   rootImage               := aRemoteImages[ 1 ]

   ::meterProcesoText( "Guardando imagen " + alltrim( rootImage ) + " en la base de datos" )

   if ( D():ArticuloImagenes( ::getView() ) )->( dbseek( idProductGestool ) )

      while ( alltrim( ( D():ArticuloImagenes( ::getView() ) )->cCodArt ) == alltrim( idProductGestool ) ) .and. ( D():ArticuloImagenes( ::getView() ) )->( !eof() ) 

         if alltrim( ( D():ArticuloImagenes( ::getView() ) )->cImgArt ) == alltrim( cNameImage ) 
            if ( D():ArticuloImagenes( ::getView() ) )->( dbrlock() )
               ( D():ArticuloImagenes( ::getView() ) )->cRmtArt   := rootImage 
               ( D():ArticuloImagenes( ::getView() ) )->( dbunlock() )
            end if 
         end if 

         ( D():ArticuloImagenes( ::getView() ) )->( dbskip() )

      end while

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getCoverValue( lValue )

   if lValue
      RETURN '1'
   end if 

   if ::TComercioConfig():isCoverValueNull()
      RETURN 'null'
   end if 

RETURN '0'

//---------------------------------------------------------------------------//

