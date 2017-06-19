#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define __tipoProducto__      1
#define __tipoCategoria__     2     

//---------------------------------------------------------------------------//

CLASS TComercioCategory FROM TComercioConector

   DATA  idCategoryDefault  

   DATA  aCategoriesProduct                                 INIT {}

   METHOD buildCategory( id, rootCategory )
   METHOD getOrBuildCategory( id, rootCategory ) 

   METHOD insertCategories()
      METHOD insertCategory()
      METHOD getCategoryLangs()
         METHOD insertCategoryLang()
      METHOD insertCategoryShop()
      METHOD insertCategoryGroup( hCategory, idCategory )

   METHOD buildRootCategoryInformation() 
      METHOD buildRootCategoryLangs()

   METHOD getParentCategory( idCategory ) 
   METHOD getNodeParentCategory( idCategory )

   METHOD updateCategoriesParent()
      METHOD updateCategoryParent( hCategory )

   METHOD recalculatePositionsCategory()

   METHOD truncateAllTables() 
      
   METHOD cleanGestoolReferences()

   METHOD buildImageCategory( hCategoryProduct )
   METHOD uploadImageCategory( hCategoryProduct )

   METHOD insertTopMenuPs()

   METHOD cleanCategoriesProduct()                          INLINE ( ::aCategoriesProduct := {} )

END CLASS

//---------------------------------------------------------------------------//

METHOD buildCategory( id, rootCategory ) CLASS TComercioCategory

   local idLang
   local aLangs            := {}
   local categoryName
   local statusFamilias
   local categoryLongName

   if hb_isnil( rootCategory )
      rootCategory         := 2
   end if 

/*
   if !( ::isSyncronizeAll() )
      RETURN .f. 
   end if 
*/
   
   if ascan( ::aCategoriesProduct, {|h| hGet( h, "id" ) == id } ) != 0
      RETURN .f.
   end if

   statusFamilias          := aGetStatus( D():Familias( ::getView() ) ) 

   if ( D():Familias( ::getView() ) )->( dbseekinord( id, "cCodFam" ) )  

      if !empty( ( D():Familias( ::getView() ) )->cFamCmb )
         ::buildCategory( ( D():Familias( ::getView() ) )->cFamCmb )
      end if

      categoryName         := alltrim( ( D():Familias( ::getView() ) )->cNomFam )

      if !empty( ( D():Familias( ::getView() ) )->cDesWeb )
         categoryName      := alltrim( ( D():Familias( ::getView() ) )->cDesWeb )
      end if  

      if !empty( ( D():Familias( ::getView() ) )->mLngDes )
         categoryLongName  := alltrim( ( D():Familias( ::getView() ) )->mLngDes )
      else
         categoryLongName  := categoryName
      end if  

      aLangs               := ::getCategoryLangs( id, categoryName, categoryLongName )

      aAdd( ::aCategoriesProduct,   {  "id"                 => id,;
                                       "id_parent"          => alltrim( ( D():Familias( ::getView() ) )->cFamCmb ),;
                                       "name"               => categoryName,;
                                       "description"        => categoryName,;
                                       "link_rewrite"       => cLinkRewrite( categoryName ),;
                                       "root_category"      => rootCategory,;
                                       "image"              => cFileBmpName( alltrim( ( D():Familias( ::getView() ) )->cImgBtn ) ),;
                                       "cPrefijoNombre"     => "",;
                                       "aTypeImages"        => {},;
                                       "langs"              => aLangs } )

   end if   

   setStatus( D():Familias( ::getView() ), statusFamilias ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getOrBuildCategory( id, rootCategory ) 

   local idCategory

   idCategory     := ::TPrestashopId():getValueCategory( id, ::getCurrentWebName() )

   msgalert( idCategory, "idCategory" )

   if empty( idCategory )

      msgalert( "cleanCategoriesProduct" )

      ::cleanCategoriesProduct()

      msgalert( "buildCategory")

      ::buildCategory( id, rootCategory )

      idCategory  := ::insertCategories()

      msgalert( hb_valtoexp( ::aCategoriesProduct ), "updateCategoriesParent" )

      ::updateCategoriesParent()

      msgalert( idCategory, "idCategory" )

   end if 

RETURN ( idCategory )

//---------------------------------------------------------------------------//

METHOD truncateAllTables() CLASS TComercioCategory

   local tableToDelete
   local tablesToDelete := {  "category",;
                              "category_lang",;
                              "category_product",;
                              "category_group",;
                              "category_shop" }

   for each tableToDelete in tablesToDelete
      ::truncateTable( tableToDelete )
   next 

RETURN ( self )

//---------------------------------------------------------------------------//
//
// Insertamos el root en la tabla de categorias
//

METHOD cleanGestoolReferences() CLASS TComercioCategory

   ::writeText( "Limpiamos las referencias de las tablas de familias" )

   ::TPrestashopId():deleteDocumentValuesCategory( ::getCurrentWebName() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildRootCategoryInformation() CLASS TComercioCategory

   local statusFamilias

   if ( D():Familias( ::getView() ) )->( dbseekinord( "Root", "cType" ) )  
      ::buildCategory( ( D():Familias( ::getView() ) )->cCodFam, 0 )
   else 
      RETURN ( .f. )
   end if 

   if ( D():Familias( ::getView() ) )->( dbseekinord( "Start", "cType" ) )  
      ::buildCategory( ( D():Familias( ::getView() ) )->cCodFam, 1 )
   else 
      RETURN ( .f. )
   end if 

   SysRefresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertCategories() CLASS TComercioCategory

   local idCategory
   local hCategoryProduct

   for each hCategoryProduct in ::aCategoriesProduct

      idCategory  := ::insertCategory( hCategoryProduct )
   
      if !empty( idCategory )

         ::insertCategoryLang( hCategoryProduct, idCategory )
         ::insertCategoryShop( hCategoryProduct, idCategory )
         ::insertCategoryGroup( hCategoryProduct, idCategory )

         ::buildImageCategory( hCategoryProduct )
         ::uploadImageCategory( hCategoryProduct )
      
      end if 

   next 

RETURN ( idCategory )

//---------------------------------------------------------------------------//

METHOD updateCategoriesParent() CLASS TComercioCategory

   local hCategoryProduct

   for each hCategoryProduct in ::aCategoriesProduct
      ::updateCategoryParent( hCategoryProduct )
   next 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD updateCategoryParent( hCategoryProduct ) CLASS TComercioCategory

   local nParent  
   local cCommand    
   local nCategory   

   nParent           := ::TPrestashopId():getValueCategory( hGet( hCategoryProduct, "id_parent" ), ::getCurrentWebName(), 0 )
   nCategory         := ::TPrestashopId():getValueCategory( hGet( hCategoryProduct, "id" ), ::getCurrentWebName() )

   if !empty( nParent ) .and. !empty( nCategory )

      cCommand       := "UPDATE " + ::cPrefixTable( "category" )              + " " + ;
                           "SET id_parent = '" + alltrim( str( nParent ) )    + "' " + ;
                        "WHERE id_category = " + alltrim( str( nCategory ) )

      if ::commandExecDirect( cCommand )
         ::writeText( "He relacionado la familia " + hGet( hCategoryProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "category" ) )
      else
         ::writeText( "Error al relacionar la familia " + hGet( hCategoryProduct, "name" ) + " en la tabla " + ::cPrefixTable( "category" ) )
      end if

   end if 

   SysRefresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertCategory( hCategory ) CLASS TComercioCategory

   local oImagen
   local cCommand       := ""
   local idCategory     := 0
   local nLevelDepth
   local isRootCategory

   nLevelDepth          := if( hget( hCategory, "root_category" ) != nil, hget( hCategory, "root_category" ), 2 )
   isRootCategory       := if( hget( hCategory, "root_category" ) != nil, 1, 0 )

   ::writeText( "Añadiendo categoría : " + hGet( hCategory, "name" ) )

   // Insertamos una familia nueva en las tablas de prestashop-----------------

   cCommand             := "INSERT IGNORE INTO " + ::cPrefixTable( "category" ) + "( "  + ;
                              "level_depth, "                                    + ;
                              "nleft, "                                          + ;
                              "nright, "                                         + ;
                              "active, "                                         + ;
                              "date_add,  "                                      + ;
                              "date_upd, "                                       + ;
                              "position, "                                       + ;
                              "is_root_category ) "                              + ;
                           "VALUES ( "                                           + ;
                              str( nLevelDepth ) + ", "                          + ;
                              "0, "                                              + ;
                              "0, "                                              + ;
                              "1, "                                              + ;
                              "'" + dtos( GetSysDate() ) + "', "                 + ;
                              "'" + dtos( GetSysDate() ) + "', "                 + ;
                              "0, "                                              + ;
                              quoted( isRootCategory )                           + " ) "

   if ::commandExecDirect( cCommand )
      idCategory        := ::oConexionMySQLDatabase():GetInsertId()
      ::writeText( "He insertado la familia " + hGet( hCategory, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "category" ), 3 )
   else
      ::writeText( "Error al insertar la familia " + hGet( hCategory, "name" ) + " en la tabla " + ::cPrefixTable( "category" ), 3 )
   end if

   SysRefresh()

   //Insertamos un registro en las tablas de imágenes----------------------

   if !empty( hGet( hCategory, "image" ) )
      hset( hCategory, "cPrefijoNombre", alltrim( str( idCategory ) ) )
   end if

   // Guardo referencia a la web-----------------------------------------------

   if !empty( idCategory )
      ::TPrestashopId:setValueCategory( hget( hCategory, "id" ), ::getCurrentWebName(), idCategory )
   end if 

RETURN ( idCategory )

//---------------------------------------------------------------------------//

METHOD buildRootCategoryLangs()

   ::insertCategoryLang( ::getLanguage() )

   if !empty( ::TComercioConfig():getLangs() )
      heval( ::TComercioConfig():getLangs(), {|k,v| ::insertCategoryLang( v ) } )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getCategoryLangs( id, categoryName, categoryLongName )

   local cName
   local hLang
   local aLangs         := {}
   local cLongName

   aadd( aLangs,        {  'lang'         => {|| ::getLanguage() },; 
                           'name'         => categoryName,; 
                           'description'  => categoryLongName,; 
                           'link_rewrite' => cLinkRewrite( categoryName ) } )

   for each hLang in ( ::TComercioConfig():getLangs() )
      
      if ( D():FamiliasLenguajes( ::getView() ) )->( dbseekinord( id + hLang:__enumKey, "cCodLen" ) )
         cName          := alltrim( ( D():FamiliasLenguajes( ::getView() ) )->cDesFam )
      else 
         cName          := categoryName
      end if 

      if ( D():FamiliasLenguajes( ::getView() ) )->( dbseekinord( id + hLang:__enumKey, "cCodLen" ) )
         cLongName      := alltrim( ( D():FamiliasLenguajes( ::getView() ) )->mLngDes )
      else 
         cLongName      := categoryLongName
      end if 

      aadd( aLangs,     {  'lang'         => hLang:__enumValue,; 
                           'name'         => cName,; 
                           'description'  => cLongName,; 
                           'link_rewrite' => cLinkRewrite( cName ) } )

   next 

   /*
   ::insertCategoryLang( idCategory, ::getLanguage(), hGet( hCategory, "name" ), hGet( hCategory, "description" ), hGet( hCategory, "link_rewrite" ) )

   if empty( ::TComercioConfig():getLangs() )
      RETURN ( Self )
   end if 

   for each hLang in ( ::TComercioConfig():getLangs() )

      if ( D():FamiliasLenguajes( ::getView() ) )->( dbseekinord( hget( hCategory, "id" ) + hLang:__enumKey, "cCodLen" ) )
         ::insertCategoryLang( idCategory, hLang:__enumValue, ( D():FamiliasLenguajes( ::getView() ) )->cDesFam, hGet( hCategory, "description" ), hGet( hCategory, "link_rewrite" ) )
      else 
         ::insertCategoryLang( idCategory, hLang:__enumValue, hGet( hCategory, "name" ), hGet( hCategory, "description" ), hGet( hCategory, "link_rewrite" ) )
      end if 

   next 
   */

RETURN ( aLangs )

//---------------------------------------------------------------------------//

METHOD insertCategoryLang( hCategoryProduct, idCategory )

   local hLang
   local idLang
   local cCommand

   for each hLang in ( hget( hCategoryProduct, "langs" ) )

      if hb_isblock( hget( hLang, "lang") )
         idLang         := eval( hget( hLang, "lang") )
      else 
         idLang         := hget( hLang, "lang")
      end if 

      idLang            := cvaltostr( idLang )

      cCommand          := "INSERT IGNORE INTO " + ::cPrefixTable( "category_lang" ) + " ( "  + ;
                              "id_category, "                                          + ;
                              "id_lang, "                                              + ;
                              "name, "                                                 + ;
                              "description, "                                          + ;
                              "link_rewrite ) "                                        + ;
                           "VALUES ( "                                                 + ;
                              alltrim( str( idCategory ) ) + ", "                      + ;
                              alltrim( idLang ) + ", "                                 + ;
                              quoted( hget( hLang, 'name' ) ) + ", "                   + ;
                              quoted( hget( hLang, 'description' ) ) + ", "            + ;
                              quoted( hget( hLang, 'link_rewrite' ) ) + " ) "


      if ::commandExecDirect( cCommand )
         ::writeText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
      else
         ::writeText( "Error al insertar la categoría raiz", 3 )
      end if

   next 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertCategoryShop( hCategory, idCategory ) CLASS TComercioCategory

   local cCommand

   cCommand             := "INSERT IGNORE INTO " + ::cPrefixTable( "category_shop" ) + "( "   + ;
                              "id_category, "                                          + ;
                              "id_shop, "                                              + ;
                              "position ) "                                            + ;
                           "VALUES ( "                                                 + ;
                              "'" + alltrim( str( idCategory ) ) + "', "               + ;
                              "'1', "                                                  + ;
                              "'0' )"

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar la categoría inicio en " + ::cPrefixTable( "category_shop" ), 3 )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertCategoryGroup( hCategory, idCategory ) CLASS TComercioCategory

   local cCommand

   cCommand             := "INSERT IGNORE INTO " + ::cPrefixTable( "category_group" ) + " "   + ;
                              "( id_category, id_group ) "                             + ;
                           "VALUES "                                                   + ;
                              "( " + alltrim( str( idCategory ) ) + ", 1 ), "          + ;
                              "( " + alltrim( str( idCategory ) ) + ", 2 ), "          + ;
                              "( " + alltrim( str( idCategory ) ) + ", 3 ) "

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar la familia " + hGet( hCategory, "name" ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getParentCategory( idCategory ) CLASS TComercioCategory

   local idParentCategory    := 2

   if D():gotoFamilias( idCategory, ::getView() ) 
      idParentCategory       := ::TPrestashopId():getValueCategory( idCategory, ::getCurrentWebName() )  
   end if

RETURN ( idParentCategory )

//---------------------------------------------------------------------------//

METHOD getNodeParentCategory( idCategory ) CLASS TComercioCategory

   local idNode            := ""

   if !empty( idCategory ) .and. D():gotoFamilias( idCategory, ::getView() ) 
      idNode               := ( D():Familias( ::getView() ) )->cFamCmb
   end if   

RETURN ( idNode )

//---------------------------------------------------------------------------//

METHOD recalculatePositionsCategory() CLASS TComercioCategory

   local nPos              := 0
   local nContador         := 2
   local cQuery
   local oQuery         
   local cCommand
   local nTotalCategory
   local nLeft             := 0  
   local nRight            := 0

   /*
   Recorremos el Query con la consulta-----------------------------------------
   */

   cQuery                  := 'SELECT * FROM ' + ::cPrefixTable( "category" )
   oQuery                  := ::queryExecDirect( cQuery )
   if !( oQuery:Open() )
      ::meterProcesoText( "Error al ejecutar " + "SELECT * FROM " + ::cPrefixTable( "category" ) )
      RETURN ( .f. )
   end if

   nTotalCategory          := oQuery:RecCount()

   if nTotalCategory == 0
      ::writeText( "No hay elementos en la categoría" )
      RETURN ( .f. )
   end if

   oQuery:GoTop()
   while !oQuery:Eof()

      do case
         case oQuery:FieldGet( 1 ) == 1

            cCommand    := "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft = '1', nRight='" + alltrim( str( nTotalCategory * 2 ) ) + "' WHERE id_category = 1" 
            if !::commandExecDirect( cCommand )
               ::writeText( "Error al actualizar el grupo de familia en la tabla category", 3 )
            end if

         case oQuery:FieldGet( 1 ) == 2

            cCommand    := "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft = '2', nRight='" + alltrim( str( ( nTotalCategory * 2 ) -1 ) ) + "' WHERE id_category = 2"
            if !::commandExecDirect( cCommand )
               ::writeText( "Error al actualizar el grupo de familia en la tabla category", 3 )
            end if

         otherwise

            nLeft       := ++nContador
            nRight      := ++nContador

            cCommand    := "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft = '" + alltrim( str( nLeft ) ) + "', nRight='" + alltrim( str( nRight ) ) + "' WHERE id_category = " + alltrim( str( oQuery:FieldGet( 1 ) ) )
            if !::commandExecDirect( cCommand )
               ::writeText( "Error al actualizar el grupo de familia en la tabla category", 3 )
            end if

      end case               

      oQuery:Skip()

   end while

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildImageCategory( hCategoryProduct )

   local oTipoImage
   local fileImage
   local cTmpFile

   fileImage   := hget( hCategoryProduct, "image" )

   if !File( fileImage )
      RETURN nil
   end if
   
   cTmpFile    := cPatTmp() + hget( hCategoryProduct, "cPrefijoNombre" ) + ".jpg"

   saveImage( fileImage, cTmpFile )

   aadd( hget( hCategoryProduct, "aTypeImages" ), cTmpFile )

   for each oTipoImage in ::aTypeImagesPrestashop()

      if !Empty( hget( hCategoryProduct, "image" ) ) .and. oTipoImage:lCategories

         if File( fileImage )

            cTmpFile    := cPatTmp() + hget( hCategoryProduct, "cPrefijoNombre" ) + "-" + oTipoImage:cNombreTipo + ".jpg"

            saveImage( fileImage, cTmpFile, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

            aadd( hget( hCategoryProduct, "aTypeImages" ), cTmpFile )

         end if

         SysRefresh()

      end if 

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD uploadImageCategory( hCategoryProduct )

   local cTypeImage
   local cRemoteImage

   if !hhaskey( hCategoryProduct, "aTypeImages")
      RETURN ( nil )
   end if 

   for each cTypeImage in hget( hCategoryProduct, "aTypeImages" )

      ::meterProcesoText( "Subiendo imagen " + cTypeImage )

      ::oFtp():CreateFile( cTypeImage, ::cDirectoryCategories() + "/" )

      SysRefresh()

      ferase( cTypeImage )

      SysRefresh()

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertTopMenuPs() CLASS TComercioCategory

   local cQuery
   local oQuery
   local aConfig
   local cConfig           := ""
   local cResult           := ""
   local aCategories       := {}
   local cCategory         := ""

   /*
   obtenemos los valores de configuración que hay actualmente------------------
   */

   cQuery                  := "SELECT * FROM " + ::cPrefixTable( "configuration" ) + " WHERE name = 'MOD_BLOCKTOPMENU_ITEMS'"
   oQuery                  := ::queryExecDirect( cQuery )

   if !( oQuery:Open() )
      ::meterProcesoText( "Error al ejecutar " + "SELECT * FROM " + ::cPrefixTable( "configuration" ) + " WHERE name = 'MOD_BLOCKTOPMENU_ITEMS'" )
      RETURN ( .f. )
   end if

   aConfig                 := hb_atokens( oQuery:FieldGetByName( "value" ), "," )

   /*
   obtenemos los valores de las categorias que queremos meter------------------
   */
   
   cQuery                  := "SELECT * FROM " + ::cPrefixTable( "category" ) + " WHERE id_parent=2"
   oQuery                  := ::queryExecDirect( cQuery )

   if !( oQuery:Open() )
      ::meterProcesoText( "Error al ejecutar " + "SELECT * FROM " + ::cPrefixTable( "category" ) )
   end if
   
   if oQuery:RecCount() > 0

      oQuery:GoTop()
         
      while !oQuery:Eof()

         aAdd( aCategories, "CAT" + AllTrim( Str( oQuery:FieldGet( 1 ) ) ) )

         oQuery:Skip()

      end while

   end if

   /*
   Fusionamos los dos arrays y creamos la cadena que vamos a guardar-----------
   */

   for each cCategory in aCategories
      cResult  += cCategory + ","
   next

   for each cConfig in aConfig
      if substr( cConfig, 1, 3 ) != "CAT"
         cResult  += cConfig + ","
      end if
   next

   /*
   Actualizamos la tabla de confugiración--------------------------------------
   */

   cQuery    := "UPDATE " + ::cPrefixTable( "configuration" ) + " SET value = '" + cResult + "' WHERE name = 'MOD_BLOCKTOPMENU_ITEMS'"
   if !::commandExecDirect( cQuery )
      ::meterProcesoText( "Error al actualizar top menu" )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//