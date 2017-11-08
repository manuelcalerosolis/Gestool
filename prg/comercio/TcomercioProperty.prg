#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioProperty FROM TComercioConector

   DATA  idManufacturer    

   DATA  aPropertiesHeaderProduct                           INIT  {}
   DATA  aPropertiesLineProduct                             INIT  {}

   METHOD cleanProperties()                                 INLINE   ( ::aPropertiesLineProduct := {}, ::aPropertiesLineProduct := {} )

   METHOD insertPropertiesHeader( hPropertiesHeaderProduct )
      METHOD insertPropertiesLineProduct( hPropertiesLineProduct, nPosition )
      
   METHOD getOrBuildProperties()
      METHOD insertPropertiesPrestashop()
   
   METHOD buildPropertyProduct( id ) 

   METHOD processPropertyProduct( idProduct, hProduct )
      METHOD insertProductAttributePrestashop( idProduct, hProduct, priceProperty )
      METHOD insertProductAttributeCombination( idFirstProperty, valueFirstProperty, idProperty )
      METHOD insertProductAttributeShop( lDefault, idProduct, idProperty, priceProperty )
      METHOD insertProductAttributeImage( hProduct, idProductAttribute )

END CLASS

//---------------------------------------------------------------------------//

METHOD getOrBuildProperties( id ) 

   local idProperty

   idProperty        := ::TPrestashopId():getValueAttributeGroup( id, ::getCurrentWebName() )

   if empty( idProperty )

      ::cleanProperties()

      ::buildPropertyProduct( id )

      ::insertPropertiesPrestashop()

   end if 

RETURN ( idProperty )

//---------------------------------------------------------------------------//

METHOD buildPropertyProduct( id ) 

   if !( D():gotoArticulos( id, ::getView() ) )
      RETURN ( Self )
   end if  

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

   if ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbseek( id ) ) 

      while ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodArt == ( D():Articulos( ::getView() ) )->Codigo .and. !( D():ArticuloPrecioPropiedades( ::getView() ) )->( eof() )

         if D():gotoIdPropiedadesLineas( ( D():ArticuloPrecioPropiedades( ::getView() ) )->cCodPr1 + ( D():ArticuloPrecioPropiedades( ::getView() ) )->cValPr1, ::getView() )

            if ::isSyncronizeAll() .or. ;
               ::TPrestashopId():getValueAttribute( ( D():PropiedadesLineas( ::getView() ) )->cCodPro + ( D():PropiedadesLineas( ::getView() ) )->cCodTbl, ::getCurrentWebName() ) == 0

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

            if ::isSyncronizeAll() .or. ;
               ::TPrestashopId():getValueAttribute( ( D():PropiedadesLineas( ::getView() ) )->cCodPro + ( D():PropiedadesLineas( ::getView() ) )->cCodTbl, ::getCurrentWebName() ) == 0

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertPropertiesPrestashop()
   
   local hPropertiesLineProduct
   local hPropertiesHeaderProduct

   ::meterProcesoSetTotal( len( ::aPropertiesHeaderProduct ) )

   for each hPropertiesHeaderProduct in ::aPropertiesHeaderProduct

      ::insertPropertiesHeader( hPropertiesHeaderProduct )

      ::meterProcesoText( "Subiendo propiedad " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aPropertiesHeaderProduct))) )

   next

   // Subimos las Lineas de propiedades necesarias-----------------------------

   ::meterProcesoSetTotal( len( ::aPropertiesLineProduct ) )

   asort( ::aPropertiesLineProduct, , , {|x,y| hget( x, "position" ) < hget( y, "position" ) } )

   for each hPropertiesLineProduct in ::aPropertiesLineProduct

      ::insertPropertiesLineProduct( hPropertiesLineProduct, hb_enumindex() )

      ::meterProcesoText( "Subiendo propiedad " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aPropertiesLineProduct))) )

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertPropertiesHeader( hPropertiesHeaderProduct )

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
                                 "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hPropertiesHeaderProduct, "name" ) ) + "', " + ;  // name
                                 "'" + ::oConexionMySQLDatabase():escapeStr( hGet( hPropertiesHeaderProduct, "name" ) ) + "' )"      // public_name

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesHeaderProduct, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_group_lang" ), 3 )
      end if

      // Guardo referencia a la web--------------------------------------------

      ::TPrestashopId():setValueAttributeGroup( hget( hPropertiesHeaderProduct, "id" ), ::getCurrentWebName(), idPrestashop )

   end if 

RETURN self

//---------------------------------------------------------------------------//

METHOD insertPropertiesLineProduct( hPropertiesLineProduct, nPosition )

   local cCommand          := ""
   local idPrestashop      := 0
   local nCodigoGrupo      := ::TPrestashopId():getValueAttributeGroup( hGet( hPropertiesLineProduct, "idparent" ), ::getCurrentWebName() )

   if empty( hGet( hPropertiesLineProduct, "idparent" ) ) .and. empty( hGet( hPropertiesLineProduct, "id" ) )
      RETURN ( self )
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
      idPrestashop         := ::oConexionMySQLDatabase():GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + hGet( hPropertiesLineProduct, "name" ) + " en la tabla " + ::cPreFixtable( "attribute" ), 3 )
   end if

   if !empty( idPrestashop )

      cCommand             := "INSERT IGNORE INTO " + ::cPrefixTable( "attribute_lang" ) + " ( " + ;
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

      cCommand             := "INSERT IGNORE INTO " + ::cPrefixTable( "attribute_shop" ) + " ( " + ;
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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD processPropertyProduct( idProduct, hProduct ) 

   local lDefault          := .t.
   local idProperty        := 0
   local priceProperty     := 0
   local aImagesProperty

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

            aImagesProperty        := hb_aTokens( ( D():ArticuloPrecioPropiedades( ::getView() ) )->mImgWeb, "," )

            if hb_isArray( aImagesProperty ) .and. len( aImagesProperty ) > 0
               ::insertProductAttributeImage( hProduct, idProperty, aImagesProperty )
            end if

         end if 

         ( D():ArticuloPrecioPropiedades( ::getView() ) )->( dbskip() )

         lDefault          := .f.

      end while

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD insertProductAttributePrestashop( idProduct, hProduct, priceProperty ) 

   local cCommand
   local idProductAttribute   := 0

   // Metemos la propiedad de íste artículo------------------------------------

   cCommand                   := "INSERT IGNORE INTO " + ::cPrefixTable( "product_attribute" ) + " ( "                              + ;
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

RETURN ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeCombination( idFirstProperty, valueFirstProperty, idProperty ) 

   local cCommand
   local idAttribute
   local idProductAttributeCombination   

   if !( ( D():PropiedadesLineas( ::getView() ) )->( dbseekinord( upper( idFirstProperty ) + upper( valueFirstProperty ), "cCodPro" ) ) )
      ::writeText( "Error al buscar en tabla de propiedades " + alltrim( idFirstProperty ) + " : " + alltrim( valueFirstProperty ), 3 )
      RETURN .f.
   end if 

   idAttribute := ::TPrestashopId():getValueAttribute( idFirstProperty + valueFirstProperty, ::getCurrentWebName() ) 

   cCommand    := "DELETE FROM " +  ::cPrefixtable( "product_attribute_combination" ) + " "  + ;
                     "WHERE id_attribute = " + alltrim( str( idAttribute ) ) + " "           + ;
                     "AND id_product_attribute = " + alltrim( str( idProperty ) )

   if !::commandExecDirect( cCommand ) 
      ::writeText( "Error al eliminar la propiedad " + alltrim( str( idAttribute ) ) + " en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )
   end if

   cCommand    := "INSERT IGNORE INTO " + ::cPrefixtable( "product_attribute_combination" ) + "( " + ;
                     "id_attribute, "                                                        + ;
                     "id_product_attribute ) "                                               + ;
                  "VALUES ("                                                                 + ;
                     "'" + alltrim( str( idAttribute ) ) + "', "                             + ;   //id_attribute
                     "'" + alltrim( str( idProperty ) ) + "' )"                                    //id_product_attribute

   if !( ::commandExecDirect( cCommand ) )
      ::writeText( "Error al insertar la propiedad " + alltrim( ( D():PropiedadesLineas( ::getView() ) )->cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )
   end if

RETURN ( idProductAttributeCombination )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeShop( idProduct, idProperty, priceProperty, lDefault ) 

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

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeImage( hProduct, idProductAttribute, aImagesProperty )

   local cImage
   local idImage
   local nPos
   local aImages
   local cCommand
   local idProductImage

   aImages              := hget( hProduct, "aImages" )

   if empty( aImages )
      RETURN ( self )
   end if 

   for each cImage in aImagesProperty

      nPos     := ascan( aImages, {|a| hGet( a, "name" ) == cImage } )

      if nPos != 0

         idImage  := hGet( aImages[nPos], "id" ) 

         idProductImage    := ::TPrestashopId():getValueImage( hGet( hProduct, "id" ) + str( idImage, 10 ), ::getCurrentWebName() )

      else

      end if

      cCommand          := "DELETE FROM " +  ::cPrefixtable( "product_attribute_image" ) + " "              + ;
                              "WHERE id_product_attribute = " + alltrim( str( idProductAttribute ) ) + " "  + ;
                              "AND id_image = " + alltrim( str( idProductImage ) )

      if !::commandExecDirect( cCommand ) 
         ::writeText( "Error al eliminar el artículo " + cImage + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )
      end if

      cCommand          := "INSERT IGNORE INTO " + ::cPrefixTable( "product_attribute_image" ) + " ( " + ;
                              "id_product_attribute, "                                          + ;
                              "id_image ) "                                                     + ;
                           "VALUES ( "                                                          + ;
                              "'" + alltrim( str( idProductAttribute ) ) + "', "                + ;   // id_product_attribute
                              "'" + alltrim( str( idProductImage ) ) + "' )"                         // id_image

      if !::commandExecDirect( cCommand )
         ::writeText( "Error al insertar el artículo " + cImage + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )
      end if

   next   

RETURN ( self )

//---------------------------------------------------------------------------//