#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioProduct

   DATA  TComercio

   DATA  aProduct                                           INIT {}
   DATA  aIvaProduct                                        INIT {}
   DATA  aManufacturerProduct                               INIT {}
   DATA  aCategoryProduct                                   INIT {}
   DATA  aPropertiesHeaderProduct                           INIT {}
   DATA  aPropertiesLineProduct                             INIT {}

   METHOD New( TComercio )                                  CONSTRUCTOR

   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                                   INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                               INLINE ( ::TComercio:TPrestashopConfig )

   METHOD isSyncronizeAll()                                 INLINE ( ::TComercio:lSyncAll )

   METHOD getCurrentWebName()                               INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                                INLINE ( ::TComercio:writeText( cText ) )

   METHOD oStock()                                          INLINE ( ::TComercio:oStock )

   METHOD oConexionMySQLDatabase()                          INLINE ( ::TComercio:oCon )

   METHOD cPrefixtable( cTable )                            INLINE ( ::TComercio:cPrefixTable( cTable ) )

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

   METHOD isProductInCurrentWeb()                           

   METHOD buildProductInformation( idProduct )
      METHOD buildIvaProduct( id )  
      METHOD buildManufacturerProduct( id )
      METHOD buildCategoryProduct( id )
      METHOD buildPropertyProduct( id )
      METHOD buildProduct( id )
      METHOD buildPriceReductionTax()                       INLINE ( if( ::oProductDatabase():lIvaWeb, 1, 0 ) )



      METHOD imagesProduct( id )
      METHOD stockProduct( id )

   METHOD truncteAllTables() 
      METHOD truncateTable( cTable )   

   METHOD insertRootCategory() 

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

   ::buildIvaProduct(               ::oProductDatabase():TipoIva )
   ::buildManufacturerProduct(      ::oProductDatabase():cCodFab )
   ::buildCategoryProduct(          ::oProductDatabase():Familia )
   ::buildPropertyProduct(          ::oProductDatabase():Codigo )
   ::buildProduct(                  ::oProductDatabase():Codigo )

   debug( ::aProduct )

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

METHOD buildIvaProduct( id ) CLASS TComercioProduct

   if aScan( ::aIvaProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f. 
   end if 

   if ::isSyncronizeAll() .or. ::TPrestashopId():getValueTax( id, ::getCurrentWebName() ) == 0
      if ::oIvaDatabase():seekInOrd( id, "Tipo" )
         aAdd( ::aIvaProduct, {  "id"     => id,;
                                 "rate"   => alltrim( str( ::oIvaDatabase():TpIva ) ),;
                                 "name"   => alltrim( ::oIvaDatabase():DescIva ) } )
      end if 
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildManufacturerProduct( id ) CLASS TComercioProduct

   if aScan( ::aManufacturerProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if 

   if ::isSyncronizeAll() .or. ::TPrestashopId():getValueManufacturer( id, ::getCurrentWebName() ) == 0
      if ::oManufacturerDatabase():SeekInOrd( id, "cCodFab" ) .and. ::oManufacturerDatabase():lPubInt
         aAdd( ::aManufacturerProduct, {  "id"     => id,;
                                          "name"   => rtrim( ::oManufacturerDatabase():cNomFab ) } )
      end if
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildCategoryProduct( id ) CLASS TComercioProduct

   if ascan( ::aCategoryProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if

   if ::isSyncronizeAll() .or. ::TPrestashopId():getValueCategory( id, ::getCurrentWebName() ) == 0
   
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

         if ::isSyncronizeAll() .or. ::TPrestashopId:getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

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

         if ::isSyncronizeAll() .or. ::TPrestashopId:getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

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

            if ::isSyncronizeAll() .or. ::TPrestashopId:getValueAttribute( ::oPropertiesLinesDatabase():cCodPro + ::oPropertiesLinesDatabase():cCodTbl, ::getCurrentWebName() ) == 0

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

            if ::isSyncronizeAll() .or. ::TPrestashopId:getValueAttribute( ::oPropertiesLinesDatabase():cCodPro + ::oPropertiesLinesDatabase():cCodTbl, ::getCurrentWebName() ) == 0

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

   if aScan( ::aProduct, {|h| hGet( h, "id" ) == id } ) != 0
      Return ( self )
   end if 

   // Recopilar info de imagenes-----------------------------------------

   aImagesArticulos           := ::imagesProduct( id )

   aStockArticulo             := ::stockProduct( id )

   // Rellenamos el Hash-------------------------------------------------

   aAdd( ::aProduct, {  "id"                    => id,;
                        "name"                  => alltrim( ::oProductDatabase():Nombre ),;
                        "id_manufacturer"       => ::oProductDatabase():cCodFab ,;
                        "id_tax_rules_group"    => ::oProductDatabase():TipoIva ,;
                        "id_category_default"   => ::oProductDatabase():Familia ,;
                        "reference"             => ::oProductDatabase():Codigo ,;
                        "weight"                => ::oProductDatabase():nPesoKg ,;
                        "specific_price"        => ::oProductDatabase():lSbrInt,;
                        "price"                 => ::buildPriceProduct(),;
                        "reduction"             => ::buildPriceReduction(),;
                        "reduction_tax"         => ::buildPriceReductionTax(),;
                        "description"           => if( !empty( ::oProductDatabase():mDesTec ), ::oProductDatabase():mDesTec, ::oProductDatabase():Nombre ) ,; 
                        "description_short"     => alltrim( ::oProductDatabase():Nombre ) ,;
                        "link_rewrite"          => cLinkRewrite( ::oProductDatabase():Nombre ),;
                        "meta_title"            => alltrim( ::oProductDatabase():cTitSeo ) ,;
                        "meta_description"      => alltrim( ::oProductDatabase():cDesSeo ) ,;
                        "meta_keywords"         => alltrim( ::oProductDatabase():cKeySeo ) ,;
                        "lPublicRoot"           => ::oProductDatabase():lPubPor,;
                        "cImagen"               => ::oProductDatabase():cImagen,;
                        "aImages"               => aImagesArticulos,;
                        "aStock"                => aStockArticulo } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildPriceProduct() CLASS TComercio

   local priceProduct      := 0

   // calcula el precio en funcion del descuento-------------------------------

   if ::oArt:lSbrInt .and. ::oArt:pVtaWeb != 0

      priceProduct         := ::oArt:pVtaWeb

   else

      if ::oArt:lIvaWeb
         priceProduct      := round( ::oArt:nImpIva1 / ( ( nIva( ::oIva:cAlias, ::oArt:TipoIva ) / 100 ) + 1 ), 6 )
      else
         priceProduct      := ::oArt:nImpInt1
      end if

   end if 

Return ( priceProduct )

//---------------------------------------------------------------------------//
//
// calcula la reduccion sobre el precio
//

METHOD buildPriceReduction() CLASS TComercio

   local priceReduction    := 0

   if ::oArt:lSbrInt .and. ::oArt:pVtaWeb != 0

      if ::oArt:lIvaWeb
         priceReduction    := ::oArt:pVtaWeb
         priceReduction    += ::oArt:pVtaWeb * nIva( ::oIva:cAlias, ::oArt:TipoIva ) / 100
         priceReduction    -= ::oArt:nImpIva1 
      else
         priceReduction    := ::oArt:pVtaWeb 
         priceReduction    -= ::oArt:nImpInt1
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

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::nNumeroCategorias++
      ::writeText( "He insertado correctamente en la tabla categorías la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) " + ;
                     "VALUES ( '1', '" + str( ::nLanguage ) + "', 'Root', 'Root', 'Root', '', '', '' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '1', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría root en category_group", 3 )
   end if

   // Metemos la categoría de inicio de la que colgarán los grupos y las categorias

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category" ) + " ( id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position, is_root_category ) VALUES ( '1', '1', '1', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0', '1' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::nNumeroCategorias++
      ::writeText( "He insertado correctamente en la tabla categorias la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) VALUES ( '2', '" + str( ::nLanguage ) + "', 'Inicio', 'Inicio', 'Inicio', '', '', '' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '2', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   SysRefresh()

Return ( Self )

//---------------------------------------------------------------------------//

