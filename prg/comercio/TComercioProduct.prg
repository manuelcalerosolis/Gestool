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
   METHOD isProductActiveInCurrentWeb()    
   METHOD isProductDeleteInCurrentWeb()                       

   METHOD buildAllProductInformation()
   METHOD buildProductInformation( idProduct )
      METHOD buildIvaProducts( id )  
      METHOD buildManufacturerProduct( id )
      METHOD buildPropertyProduct( id )
      
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

      METHOD processPropertyProduct( idProduct, hProduct )
         METHOD insertProductAttributePrestashop( idProduct, hProduct, priceProperty )
         METHOD insertProductAttributeCombination( idFirstProperty, valueFirstProperty, idProperty )
         METHOD insertProductAttributeShop( lDefault, idProduct, idProperty, priceProperty )
         METHOD insertProductAttributeImage( hProduct, idProductAttribute )

      METHOD insertPropertiesHeader( hPropertiesHeaderProduct ) 
      METHOD insertPropertiesLineProduct( hPropertiesLineProduct )

   METHOD deleteProducts()

   METHOD insertProductCategory( idProduct, idCategory )

   METHOD insertAditionalInformation()

   METHOD truncateAllTables() 

   METHOD insertTaxPrestashop( hTax )
   METHOD insertManufacturersPrestashop( hFabricantesData )

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

   METHOD buildImagesManufacturers( hManufacturer )
   METHOD uploadImagesManufacturers( hManufacturer )

END CLASS

//---------------------------------------------------------------------------//

METHOD buildAllProductInformation() CLASS TComercioProduct

   ::writeText( "Procesando articulos ... " )

   ( D():Articulos( ::getView() ) )->( ordsetfocus( "lWebShop" ) )

   if ( D():Articulos( ::getView() ) )->( dbseek( ::getCurrentWebName() ) )

      while ( alltrim( ( D():Articulos( ::getView() ) )->cWebShop ) == ::getCurrentWebName() ) .and. !( ( D():Articulos( ::getView() ) )->( eof() ) )

         ::buildProductInformation( ( D():Articulos( ::getView() ) )->Codigo )

         ( D():Articulos( ::getView() ) )->( dbskip() )

      end while

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildProductInformation( idProduct ) CLASS TComercioProduct

   if !( ::isProductInDatabase( idProduct ) )
      Return ( .f. )
   end if 

   if !( ::isProductActiveInCurrentWeb( idProduct ) )
      Return ( .f. )
   end if 

   ::buildIvaProducts( ( D():Articulos( ::getView() ) )->TipoIva )

   ::buildManufacturerProduct( ( D():Articulos( ::getView() ) )->cCodFab )

   ::TComercioCategory():buildCategory( ( D():Articulos( ::getView() ) )->Familia )
   
   ::buildPropertyProduct( ( D():Articulos( ::getView() ) )->Codigo )
      
Return ( .t. )

//---------------------------------------------------------------------------//

METHOD isProductInDatabase( idProduct ) CLASS TComercioProduct

   if !( ( D():Articulos( ::getView() ) )->( dbseekinord( idProduct, "Codigo" ) ) )
      ::writeText( "El artículo " + alltrim( idProduct  ) + " no se ha encontrado en la base de datos" )
      Return ( .f. )
   end if 

Return ( .t. )
                                                                           
//---------------------------------------------------------------------------//

METHOD isProductActiveInCurrentWeb( idProduct ) CLASS TComercioProduct

   if !( ( D():Articulos( ::getView() ) )->lPubInt )
      ::writeText( "Artículo " + alltrim( idProduct ) + " no seleccionado para web" ) 
      Return .f.
   end if 

   if ( alltrim( ( D():Articulos( ::getView() ) )->cWebShop ) != ::getCurrentWebName() ) 
      ::writeText( "Artículo " + alltrim( idProduct ) + " no pertence a la web seleccionada" )
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD isProductDeleteInCurrentWeb( idProduct ) CLASS TComercioProduct

   if ( ( D():Articulos( ::getView() ) )->lPubInt )
      ::writeText( "Artículo " + alltrim( idProduct ) + " no eliminado de la web" ) 
      Return .f.
   end if 

   if ( alltrim( ( D():Articulos( ::getView() ) )->cWebShop ) != ::getCurrentWebName() ) 
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
      if D():gotoTiposIva( id, ::getView() )
         aadd( ::aTaxProducts,   {  "id"     => id,;
                                    "rate"   => alltrim( str( ( D():TiposIva( ::getView() ) )->TpIva ) ),;
                                    "name"   => alltrim( ( D():TiposIva( ::getView() ) )->DescIva ) } )
      end if 
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildManufacturerProduct( id ) CLASS TComercioProduct

   if !( ::isSyncronizeAll() )
      Return .f. 
   end if 

   if !( ::TComercioConfig():getSyncronizeManufacturers() )
      Return .f. 
   end if 

   if aScan( ::aManufacturersProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if 

   if ::TPrestashopId():getValueManufacturer( id, ::getCurrentWebName() ) == 0
      if D():gotoIdFabricantes( id, ::getView() ) .and. ( D():Fabricantes( ::getView() ) )->lPubInt
         aadd( ::aManufacturersProduct,   {  "id"              => id,;
                                             "name"            => rtrim( ( D():Fabricantes( ::getView() ) )->cNomFab ),;
                                             "image"           => rtrim( ( D():Fabricantes( ::getView() ) )->cImgLogo ),;
                                             "aTypeImages"     => {} ,;
                                             "cPrefijoNombre"  => "" } )
      end if
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildPropertyProduct( id ) CLASS TComercioProduct

   /*
   Primera propiedad--------------------------------------------------------
   */

   if ( D():Propiedades( ::getView() ) )->( dbseekinord( ( D():Articulos( ::getView() ) )->cCodPrp1, "cCodPro" ) )

      if aScan( ::aPropertiesHeaderProduct, {|h| hGet( h, "id" ) == ( D():Propiedades( ::getView() ) )->cCodPro } ) == 0

         if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

            aAdd( ::aPropertiesHeaderProduct,   {  "id"     => ( D():Propiedades( ::getView() ) )->cCodPro,;
                                                   "name"   => if( empty( ( D():Propiedades( ::getView() ) )->cNomInt ), alltrim( ( D():Propiedades( ::getView() ) )->cDesPro ), alltrim( ( D():Propiedades( ::getView() ) )->cNomInt ) ),;
                                                   "lColor" => ( D():Propiedades( ::getView() ) )->lColor } )

         end if

      end if 

   end if

   /*
   Segunda propiedad--------------------------------------------------------
   */

   if ( D():Propiedades( ::getView() ) )->( dbseekinord( ( D():Articulos( ::getView() ) )->cCodPrp2, "cCodPro" ) )

      if aScan( ::aPropertiesHeaderProduct, {|h| hGet( h, "id" ) == ( D():Propiedades( ::getView() ) )->cCodPro } ) == 0

         if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

            aAdd( ::aPropertiesHeaderProduct,   {  "id"     => ( D():Propiedades( ::getView() ) )->cCodPro,;
                                                   "name"   => if( empty( ( D():Propiedades( ::getView() ) )->cNomInt ), alltrim( ( D():Propiedades( ::getView() ) )->cDesPro ), alltrim( ( D():Propiedades( ::getView() ) )->cNomInt ) ),;
                                                   "lColor" => ( D():Propiedades( ::getView() ) )->lColor } )

         end if

      end if 

   end if

   /*
   Líneas de propiedades de un artículo-------------------------------------
   */

   if ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbseek( ( D():Articulos( ::getView() ) )->Codigo ) ) 

      while ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodArt == ( D():Articulos( ::getView() ) )->Codigo .and. !( D():ArticuloPrecioPropiedades( ::getView() ) )->( eof() )

         if D():gotoIdPropiedadesLineas( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr1 + ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr1, ::getView() )

            if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttribute( ( D():PropiedadesLineas( ::getView() ) )->cCodPro + ( D():PropiedadesLineas( ::getView() ) )->cCodTbl, ::getCurrentWebName() ) == 0

               if aScan( ::aPropertiesLineProduct, {|h| hGet( h, "id" ) == ( D():PropiedadesLineas( ::getView() ) )->cCodTbl .and. hGet( h, "idparent" ) == ( D():PropiedadesLineas( ::getView() ) )->cCodPro } ) == 0
      
                  aAdd( ::aPropertiesLineProduct,  {  "id"           => ( D():PropiedadesLineas( ::getView() ) )->cCodTbl,;
                                                      "idparent"     => ( D():PropiedadesLineas( ::getView() ) )->cCodPro,; 
                                                      "name"         => alltrim( ( D():PropiedadesLineas( ::getView() ) )->cDesTbl ),;
                                                      "color"        => alltrim( RgbToRgbHex( ( D():PropiedadesLineas( ::getView() ) )->nColor ) ),;
                                                      "position"     => ( D():PropiedadesLineas( ::getView() ) )->nOrdTbl } )

               end if

            end if

         end if

         if D():gotoIdPropiedadesLineas( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr2 + ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr2, ::getView() )

            if ::isSyncronizeAll() .or. ::TPrestashopId():getValueAttribute( ( D():PropiedadesLineas( ::getView() ) )->cCodPro + ( D():PropiedadesLineas( ::getView() ) )->cCodTbl, ::getCurrentWebName() ) == 0

               if aScan( ::aPropertiesLineProduct, {|h| hGet( h, "id" ) == ( D():PropiedadesLineas( ::getView() ) )->cCodTbl .and. hGet( h, "idparent" ) == ( D():PropiedadesLineas( ::getView() ) )->cCodPro } ) == 0
      
                  aAdd( ::aPropertiesLineProduct,  {  "id"           => ( D():PropiedadesLineas( ::getView() ) )->cCodTbl,;
                                                      "idparent"     => ( D():PropiedadesLineas( ::getView() ) )->cCodPro,; 
                                                      "name"         => alltrim( ( D():PropiedadesLineas( ::getView() ) )->cDesTbl ),;
                                                      "color"        => alltrim( RgbToRgbHex( ( D():PropiedadesLineas( ::getView() ) )->nColor ) ),;
                                                      "position"     => ( D():PropiedadesLineas( ::getView() ) )->nOrdTbl } )

               end if

            end if

         end if

         ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbskip() )

      end while

   end if

Return ( Self )

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
         Return ( .f. )
      end if 
   end if 

   if !( ::isProductInDatabase( idProduct ) )
      Return ( .f. )
   end if 

   if !( ::isProductActiveInCurrentWeb( idProduct ) )
      Return ( .f. )
   end if 

   // Recopilar info del stock-------------------------------------------------

   aStockArticulo             := ::stockProduct( idProduct )

   if !( ::TComercioConfig():isProcessWithoutStock() ) .and. ::isTotalStockZero( aStockArticulo )
      ::writeText( "El artículo " + alltrim( idProduct ) + " no tiene stock en el almacen de la web")
      Return ( .f. )
   end if 

   // Recopilar info de imagenes-----------------------------------------" )

   aImagesArticulos           := ::imagesProduct( idProduct )
   if !( ::TComercioConfig():isProcessWithoutImage() ) .and. empty( aImagesArticulos ) 
      ::writeText( "El artículo " + alltrim( idProduct ) + " no tiene imagenes")
      Return ( .f. )
   end if 

   // Recopilar idiomas de los productos--------------------------------------

   aLangsArticulos            := ::langsProduct( idProduct )

   // Contruimos el hash con toda la informacion del producto------------------

   ::buildHashProduct( idProduct, aImagesArticulos, aStockArticulo, aLangsArticulos )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildDeleteProduct( idProduct, lCleanProducts ) CLASS TComercioProduct

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

   if !( ::isProductDeleteInCurrentWeb( idProduct ) )
      Return ( .f. )
   end if 

   ::buildHashProduct( idProduct )

Return ( .t. )

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

Return ( ::aProducts )

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

Return ( priceProduct )

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

Return ( priceReduction )

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

Return ( aImages )

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

Return ( aLangs )

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

Return ( Self )

//---------------------------------------------------------------------------//

METHOD deleteProducts() CLASS TComercioProduct

   local hProduct
   local nProducts   := len( ::aProducts )

   ::meterProcesoSetTotal( nProducts )
   
   for each hProduct in ::aProducts

      ::meterProcesoText( "Eliminando artículo anterior " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nProducts ) ) ) 

      ::deleteProduct( hProduct )
   
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertProduct( hProduct ) CLASS TComercioProduct

   local idProduct
   local idCategory

   idCategory           := hGet( hProduct, "id_category_default" )

   // ::TComercioCategory():getOrBuildCategory( idCategory ) 

   // ::idCategoryDefault  := ::TPrestashopId():getValueCategory( idCategory, ::getCurrentWebName(), 2 )

   ::idCategoryDefault  := ::TComercioCategory():getOrBuildCategory( idCategory ) 

   ::idTaxRulesGroup    := ::TPrestashopId():getValueTaxRuleGroup( hGet( hProduct, "id_tax_rules_group" ), ::getCurrentWebName() )

   ::idManufacturer     := ::TPrestashopId():getValueManufacturer( hGet( hProduct, "id_manufacturer" ), ::getCurrentWebName() )

   // Publicar el articulo en su categoria-------------------------------------

   idProduct            := ::insertProductPrestashopTable( hProduct, idCategory )

   if ::notValidProductId( idProduct )
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

      Return ( idProduct )

   end if

Return ( idProduct )

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

Return ( self )

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
                     "'" + hGet( hLang, "shortDescription" ) + "', " + ;                                          // description_short
                     "'" + hGet( hProduct, "link_rewrite" ) + "', " + ;                                           // link_rewrite
                     "'" + hGet( hProduct, "meta_title" ) + "', " + ;                                             // Meta_título
                     "'" + hGet( hProduct, "meta_description" ) + "', " + ;                                       // Meta_description
                     "'" + hGet( hProduct, "meta_keywords" ) + "', " + ;                                          // Meta_keywords
                     "'" + hGet( hProduct, "name" ) + "', " + ;                                                   // name
                     "'En stock', " + ;                                                                           // avatible_now
                     "'' )"

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
      end if

   next 

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

Return .t.

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

Return ( idImagePrestashop )

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

Return .t.

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

Return .t.

//---------------------------------------------------------------------------//

METHOD processPropertyProduct( idProduct, hProduct ) CLASS TComercioProduct

   local lDefault          := .t.
   local idProperty        := 0
   local priceProperty     := 0

   // Comprobamos si el artículo tiene propiedades y metemos las propiedades

   if ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbSeekInOrd( hGet( hProduct, "id" ), "cCodArt" ) )

      while ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodArt == hGet( hProduct, "id" ) .and. ( D():ArticuloPrecioPropiedades( ::getView() ) )->( !eof() ) 

         if !empty( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr1 )

            priceProperty  := nPrePro( hGet( hProduct, "id" ), ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr1, ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr1, space( 20 ), space( 20 ), 1, .f., D():ArticuloPrecioPropiedades( ::getView() ) )

            idProperty     := ::insertProductAttributePrestashop( idProduct, hProduct, priceProperty )

            ::insertProductAttributeCombination( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr1, ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr1, idProperty )

            if !empty( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr2 )
            
               ::insertProductAttributeCombination( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr2, ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr2, idProperty )

            end if 

            ::TPrestashopId:setValueProductAttributeCombination( hGet( hProduct, "id" ) + ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr1 + ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr1 + ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr2 + ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr2, ::getCurrentWebName(), idProperty )        

            ::insertProductAttributeShop( idProduct, idProperty, priceProperty, lDefault )

            ::insertProductAttributeImage( hProduct, idProperty )

         end if 

         ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbskip() )

         lDefault    := .f.

      end while

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertProductAttributePrestashop( idProduct, hProduct, priceProperty ) CLASS TComercioProduct

   local cCommand
   local idProductAttribute   := 0

   // Metemos la propiedad de íste artículo---------------------------

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "product_attribute" ) + " ( "                                     + ;
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
      ::writeText( "Error al insertar la propiedad " + alltrim( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr1 ) + " - " + alltrim( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr2 ) + " en la tabla " + ::cPrefixTable( "product_attribute" ), 3 )
   end if

Return ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeCombination( idFirstProperty, valueFirstProperty, idProperty ) CLASS TComercioProduct

   local cCommand
   local idAttribute
   local idProductAttributeCombination   

   if !( ( D():PropiedadesLineas( ::getView() ) )->( dbseekinord( upper( idFirstProperty ) + upper( valueFirstProperty ), "cCodPro" ) ) )
      ::writeText( "Error al buscar en tabla de propiedades " + alltrim( idFirstProperty ) + " : " + alltrim( valueFirstProperty ), 3 )
      Return .f.
   end if 

   idAttribute := ::TPrestashopId():getValueAttribute( idFirstProperty + valueFirstProperty, ::getCurrentWebName() ) 

   cCommand    := "DELETE FROM " +  ::cPrefixtable( "product_attribute_combination" ) + " "  + ;
                     "WHERE id_attribute = " + alltrim( str( idAttribute ) ) + " "           + ;
                     "AND id_product_attribute = " + alltrim( str( idProperty ) )

   if !::commandExecDirect( cCommand ) 
      ::writeText( "Error al eliminar la propiedad " + alltrim( str( idAttribute ) ) + " en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )
   end if

   cCommand    := "INSERT IGNORE INTO " +  ::cPrefixtable( "product_attribute_combination" ) + "( " + ;
                     "id_attribute, "                                                        + ;
                     "id_product_attribute ) "                                               + ;
                  "VALUES ("                                                                 + ;
                     "'" + alltrim( str( idAttribute ) ) + "', "                             + ;   //id_attribute
                     "'" + alltrim( str( idProperty ) ) + "' )"                                    //id_product_attribute

   if !( ::commandExecDirect( cCommand ) )
      ::writeText( "Error al insertar la propiedad " + alltrim( ( D():PropiedadesLineas( ::getView() ) )->cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )
   end if

Return ( idProductAttributeCombination )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeShop( idProduct, idProperty, priceProperty, lDefault ) CLASS TComercioProduct

   local cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "product_attribute_shop" ) + " ( "  + ;
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
      ::writeText( "Error al insertar la propiedad " + alltrim( ( D():PropiedadesLineas( ::getView() ) )->cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_shop" ), 3 )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeImage( hProduct, idProductAttribute ) CLASS TComercioProduct

   local hImage
   local aImages
   local cCommand
   local idProductImage

   aImages              := hget( hProduct, "aImages" )

   if empty( aImages )
      Return ( self )
   end if 

   for each hImage in aImages

      idProductImage    := ::TPrestashopId():getValueImage( hGet( hProduct, "id" ) + str( hget( hImage, "id" ), 10 ), ::getCurrentWebName() )

      cCommand          := "DELETE FROM " +  ::cPrefixtable( "product_attribute_image" ) + " "              + ;
                              "WHERE id_product_attribute = " + alltrim( str( idProductAttribute ) ) + " "  + ;
                              "AND id_image = " + alltrim( str( idProductImage ) )

      if !::commandExecDirect( cCommand ) 
         ::writeText( "Error al eliminar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )
      end if

      cCommand          := "INSERT IGNORE INTO " + ::cPrefixTable( "product_attribute_image" ) + " ( " + ;
                              "id_product_attribute, "                                          + ;
                              "id_image ) "                                                     + ;
                           "VALUES ( "                                                          + ;
                              "'" + alltrim( str( idProductAttribute ) ) + "', "                + ;   // id_product_attribute
                              "'" + alltrim( str( idProductImage ) ) + "' )"                         // id_image

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

   idProductPrestashop                 := alltrim( str( ::TPrestashopId():getValueProduct( idProductGestool, ::getCurrentWebName() ) ) )
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

   // Eliminamos las imígenes del artículo---------------------------------------

   ::writeText( "Eliminando imígenes de prestashop" )

   ::deleteImages( idProductPrestashop )

   // Quitamos la referencia de nuestra tabla-------------------------------------

   ::writeText( "Eliminando referencias en gestool" )

   ::TPrestashopId():deleteDocumentValuesProduct( idProductGestool, ::getCurrentWebName() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD inactivateProduct( idProduct ) CLASS TComercioProduct

   local cCommand
   local idProductPrestashop 

   idProductPrestashop  := alltrim( str( ::TPrestashopId():getValueProduct( idProduct, ::getCurrentWebName() ) ) )

   if empty( idProductPrestashop )
      Return ( Self )
   end if

   ::writeText( "Desactivando artículo " + alltrim( idProduct ) + " de prestashop" )

   cCommand             := "UPDATE " + ::cPrefixTable( "product" ) + ;
                              " SET active = 0, indexed = 0" + ;
                              " WHERE id_product = '" + idProductPrestashop + "'"

   // ::commandExecDirect( cCommand )

   ::addMegaCommand( cCommand )

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

   sysrefresh()

Return ( Self )

//---------------------------------------------------------------------------//
// Subimos los ficheros de imagenes

METHOD uploadImageToPrestashop( hProduct ) CLASS TComercioProduct

   local cTypeImage
   local hProductImage
   local aProductsImages   := hGet( hProduct, "aImages" )

   if empty( aProductsImages )
      Return ( nil )
   end if 

   CursorWait()

   ::meterProcesoSetTotal( len( aProductsImages ) )

   for each hProductImage in aProductsImages

      ::buildFilesProductImages( hProductImage )

      ::ftpUploadFilesProductImages( hProductImage )

      ::putFileRootProductImage( hProductImage )

   next

   CursorWe()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD buildFilesProductImages( hProductImage ) CLASS TComercioProduct

   local rootImage
   local fileImage         
   local oTipoImage

   if !hhaskey( hProductImage, "cPrefijoNombre" )  .or.;
      !hhaskey( hProductImage, "nTipoImagen" )     .or.;
      !hhaskey( hProductImage, "aTypeImages" )     

      Return ( nil )

   end if 

   CursorWait()

   rootImage               := ::getRootImage( hProductImage )

   saveImage( hget( hProductImage, "name" ), rootImage )

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

Return ( nil )

//---------------------------------------------------------------------------//


METHOD ftpUploadFilesProductImages( hProductImage ) CLASS TComercioProduct

   local cTypeImage
   local cRemoteImage

   if !hhaskey( hProductImage, "aTypeImages")
      Return ( nil )
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

   if ::TComercioConfig():getSyncronizeManufacturers()

      ::meterProcesoSetTotal( len( ::aManufacturersProduct ) )

      for each hManufacturer in ::aManufacturersProduct

         ::insertManufacturersPrestashop( hManufacturer )

         ::buildImagesManufacturers( hManufacturer )
         ::uploadImagesManufacturers( hManufacturer )

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
   local oQuery

   cCommand := "INSERT IGNORE INTO " + ::cPreFixtable( "tax" ) + " ( " + ;
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

   // Insertamos un tipo de IVA nuevo en la tabla tax_lang------------------------

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "tax_lang" ) + "( " +;
                  "id_tax, " + ;
                  "id_lang, " + ;
                  "name ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( idTax ) ) + "', " + ;                                  // id_tax
                  ::getLanguage() + ", " + ;                                                 // id_lang
                  "'" + ::oConexionMySQLDatabase():Escapestr( hGet( hTax, "name" ) ) + "' )" // name

   if ::commandExecDirect( cCommand )
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   end if

   // Insertamos un tipo de IVA nuevo en la tabla tax_rule_group------------------

   cCommand := "INSERT IGNORE INTO "+ ::cPrefixTable( "tax_rules_group" ) + "( " + ;
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

   // Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------

   cCommand          := 'SELECT id_country FROM ' + ::cPrefixTable( "country" )
   oQuery            := ::queryExecDirect( cCommand )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "tax_rule" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_country, " + ;
                  "id_tax ) VALUES "

      while !oQuery:Eof()

         cCommand    += "( " + ;
                        "'" + alltrim( str( idGroupWeb ) ) + "', " + ;
                        "'" + AllTrim( str( oQuery:FieldGetByName( "id_country" ) ) ) + "', " + ;
                        "'" + alltrim( str( idTax ) ) + "' ), "

         oQuery:Skip()

      end while

   end if
   
   cCommand          := Substr( cCommand, 1, len( cCommand ) - 2 )

   if !::commandExecDirect( cCommand )
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------
   */

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "tax_rules_group_shop" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_shop ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( idGroupWeb ) ) + "', " + ;
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

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "manufacturer" ) + "( " +;
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
      hset( hFabricantesData, "cPrefijoNombre", alltrim( str( nCodigoWeb ) ) )
   else
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla " + ::cPreFixtable( "manufacturer" ), 3 )
   end if

   cCommand := "INSERT IGNORE INTO " + ::cPrefixTable( "manufacturer_shop" ) + "( "+ ;
                  "id_manufacturer, " + ;
                  "id_shop ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;      // id_manufacturer
                  "'1' )"                                             // id_shop                  


   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla" + ::cPreFixtable( "manufacturer_shop" ), 3 )
   end if

   cCommand := "INSERT IGNORE INTO " + ::cPreFixtable( "manufacturer_lang" ) + "( " +;
                  "id_manufacturer, " + ;
                  "id_lang ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;     // id_manufacturer
                  "'" + ::TComercio:nLanguage + "' )"         // id_lang

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

   cCommand                := "INSERT IGNORE INTO " + ::cPrefixTable( "attribute_group" ) + " ( " +; 
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
      cCommand             := "INSERT IGNORE INTO " + ::cPrefixTable( "attribute_group_lang" ) + " ( " + ; 
                                 "id_attribute_group, " + ;
                                 "id_lang, " + ;
                                 "name, " + ;
                                 "public_name ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( idPrestashop ) ) + "', " + ;            // id_attribute_group
                                 ::getLanguage() + ", " + ;                                  // id_lang
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

   if Empty( hGet( hPropertiesLineProduct, "idparent" ) ) .and. Empty( hGet( hPropertiesLineProduct, "id" ) )
      Return ( self )
   end if

   cCommand                := "INSERT IGNORE INTO " + ::cPrefixTable( "attribute" ) + " ( " + ; 
                                 "id_attribute_group, " + ;
                                 "color, " + ;
                                 "position ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( nCodigoGrupo ) ) + "', " + ;            // id_attribute_group
                                 "'" + hGet( hPropertiesLineProduct, "color" ) + "' ," + ;   // color
                                 "'" + alltrim( str( nPosition ) ) + "' )"                   // posicion

   if ::commandExecDirect( cCommand )
      idPrestashop   := ::oConexionMySQLDatabase():GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesLineProduct, "name" ) + " en la tabla " + ::cPreFixtable( "attribute" ), 3 )
   end if

   if !empty( idPrestashop )

      cCommand    := "INSERT IGNORE INTO " + ::cPrefixTable( "attribute_lang" ) + " ( " + ;
                        "id_attribute, " + ;
                        "id_lang, " + ;
                        "name ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( idPrestashop ) ) + "', " + ;                                             // id_attribute
                        ::getLanguage() + ", " + ;                                                                   // id_lang
                        "'" + ::oConexionMySQLDatabase():Escapestr( hGet( hPropertiesLineProduct, "name" ) ) + "' )" // name

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesLineProduct, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_lang" ), 3 )
      end if

      cCommand    := "INSERT IGNORE INTO " + ::cPrefixTable( "attribute_shop" ) + " ( " + ;
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

Return ( Self )

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

Return ( Self )

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

METHOD getIdProductImage( id, cImgToken ) CLASS TComercioProduct

   if ( D():ArticuloImagenes( ::getView() ) )->( dbseek( id ) )

      while ( D():ArticuloImagenes( ::getView() ) )->cCodArt == id .and. ( D():ArticuloImagenes( ::getView() ) )->( !eof() ) 

         if alltrim( ( D():ArticuloImagenes( ::getView() ) )->cImgArt ) == alltrim( cImgToken )
            Return ( ( D():ArticuloImagenes( ::getView() ) )->nId )
         end if 

         ( D():ArticuloImagenes( ::getView() ) )->( dbskip() )

      end while 

   end if 

Return ( 0 )

//---------------------------------------------------------------------------//

METHOD getDefaultProductImage( id, cImgToken ) CLASS TComercioProduct

   if ( D():ArticuloImagenes( ::getView() ) )->( dbseek( id ) )

      while ( D():ArticuloImagenes( ::getView() ) )->cCodArt == id .and. ( D():ArticuloImagenes( ::getView() ) )->( !eof() ) 

         if alltrim( ( D():ArticuloImagenes( ::getView() ) )->cImgArt ) == alltrim( cImgToken )
            Return ( ( D():ArticuloImagenes( ::getView() ) )->lDefImg )
         end if 

         ( D():ArticuloImagenes( ::getView() ) )->( dbskip() )

      end while 

   end if 

Return ( .f. )

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
      Return .f.
   end if 

   if empty( aRemoteImages ) 
      Return .f.
   end if 

   if empty( idProductGestool )
      Return .f.
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

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getCoverValue( lValue )

   if lValue
      Return '1'
   end if 

   if ::TComercioConfig():isCoverValueNull()
      Return 'null'
   end if 

Return '0'

//---------------------------------------------------------------------------//

METHOD buildImagesManufacturers( hManufacturer )

   local oTipoImage
   local fileImage
   local cTmpFile

   fileImage   := hget( hManufacturer, "image" )

   if !File( fileImage )
      Return nil
   end if

   for each oTipoImage in ::aTypeImagesPrestashop()

      if !Empty( hget( hManufacturer, "image" ) ) .and. oTipoImage:lManufactures

         if File( fileImage )

            cTmpFile    := cPatTmp() + hget( hManufacturer, "cPrefijoNombre" ) + "-" + oTipoImage:cNombreTipo + ".jpg"

            saveImage( fileImage, cTmpFile, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

            aadd( hget( hManufacturer, "aTypeImages" ), cTmpFile )

         end if

         SysRefresh()

      end if 

   next

   cTmpFile    := cPatTmp() + hget( hManufacturer, "cPrefijoNombre" ) + ".jpg"

   saveImage( fileImage, cTmpFile )

   aadd( hget( hManufacturer, "aTypeImages" ), cTmpFile )

Return nil

//---------------------------------------------------------------------------//

METHOD uploadImagesManufacturers( hManufacturer )

   local cTypeImage
   local cRemoteImage

   if !hhaskey( hManufacturer, "aTypeImages")
      Return ( nil )
   end if 

   for each cTypeImage in hget( hManufacturer, "aTypeImages" )

      ::meterProcesoText( "Subiendo imagen " + cTypeImage )

      ::oFtp():CreateFile( cTypeImage, ::cDirectoryManufacture() + "/" )

      SysRefresh()

      ferase( cTypeImage )

      SysRefresh()

   next

Return nil

//---------------------------------------------------------------------------//