#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define __tipoProducto__      1
#define __tipoCategoria__     2     

//---------------------------------------------------------------------------//

CLASS TComercioManufacturer FROM TComercioConector

   DATA  idManufacturer    

   DATA  aManufacturersProduct                              INIT {}

   METHOD getOrBuildManufacturerProduct( id )
      METHOD buildManufacturerProduct( id )
      METHOD insertManufacturersPrestashop( hManufacturers )
         METHOD insertManufacturerPrestashop( hManufacturer )
      
   METHOD cleanManufacturerProduct()                        INLINE ( ::aManufacturersProduct := {} )

   METHOD buildImagesManufacturers( hManufacturer )
   METHOD uploadImagesManufacturers( hManufacturer )

END CLASS

//---------------------------------------------------------------------------//

METHOD getOrBuildManufacturerProduct( id )

   local hManufacturerProduct
   local idManufacturerProduct   := ::TPrestashopId():getValueManufacturer( id, ::getCurrentWebName() )

   if empty( idManufacturerProduct )

      ::cleanManufacturerProduct()

      ::buildManufacturerProduct( id )

      for each hManufacturerProduct in ::aManufacturersProduct

         idManufacturerProduct   := ::insertManufacturerPrestashop( hManufacturerProduct )

         ::buildImagesManufacturers( hManufacturerProduct )
         
         ::uploadImagesManufacturers( hManufacturerProduct )

      next

   end if 

RETURN ( idManufacturerProduct )

//---------------------------------------------------------------------------//

METHOD buildManufacturerProduct( id ) 

   if !( ::TComercioConfig():getSyncronizeManufacturers() )
      RETURN .f. 
   end if 

   if aScan( ::aManufacturersProduct, {|h| hGet( h, "id" ) == id } ) != 0
      RETURN .f.
   end if 

   if ::TPrestashopId():getValueManufacturer( id, ::getCurrentWebName() ) != 0
      RETURN .f.
   end if 

   if D():gotoIdFabricantes( id, ::getView() )
      aadd( ::aManufacturersProduct,   {  "id"              => id,;
                                          "name"            => rtrim( ( D():Fabricantes( ::getView() ) )->cNomFab ),;
                                          "image"           => rtrim( ( D():Fabricantes( ::getView() ) )->cImgLogo ),;
                                          "aTypeImages"     => {} ,;
                                          "cPrefijoNombre"  => "" } )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertManufacturersPrestashop()

   local hManufacturer

   if !( ::TComercioConfig():getSyncronizeManufacturers() )
      RETURN ( Self )
   end if

   ::meterProcesoSetTotal( len( ::aManufacturersProduct ) )

   for each hManufacturer in ::aManufacturersProduct

      ::insertManufacturerPrestashop( hManufacturer )

      ::buildImagesManufacturers( hManufacturer )

      ::uploadImagesManufacturers( hManufacturer )

      ::meterProcesoText( "Subiendo fabricantes " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aManufacturersProduct))) )

   next 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertManufacturerPrestashop( hManufacturer )

   local oImagen
   local nParent           := 1
   local cCommand          := ""    
   local idManufacturer    := 0

   /*
   Insertamos un fabricante nuevo en las tablas de prestashop-----------------
   */

   cCommand                := "INSERT IGNORE INTO " + ::cPrefixTable( "manufacturer" ) + "( " +;
                                 "name, " + ;
                                 "date_add, " + ;
                                 "date_upd, " + ;
                                 "active ) " + ;
                              "VALUES ( " + ;
                                 "'" + hGet( hManufacturer, "name" ) + "', " + ; //name
                                 "'" + dtos( GetSysDate() ) + "', " + ;             //date_add
                                 "'" + dtos( GetSysDate() ) + "', " + ;             //date_upd
                                 "'1' )"                                            //active

   if ::commandExecDirect( cCommand )
      idManufacturer       := ::oConexionMySQLDatabase():GetInsertId()
      hset( hManufacturer, "cPrefijoNombre", alltrim( str( idManufacturer ) ) )
   else
      ::writeText( "Error al insertar el fabricante " + hGet( hManufacturer, "name" ) + " en la tabla " + ::cPreFixtable( "manufacturer" ), 3 )
   end if

   cCommand                := "INSERT IGNORE INTO " + ::cPrefixTable( "manufacturer_shop" ) + "( "+ ;
                                 "id_manufacturer, " + ;
                                 "id_shop ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( idManufacturer ) ) + "', " + ;      // id_manufacturer
                                 "'1' )"                                             // id_shop                  


   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el fabricante " + hGet( hManufacturer, "name" ) + " en la tabla" + ::cPreFixtable( "manufacturer_shop" ), 3 )
   end if

   cCommand                := "INSERT IGNORE INTO " + ::cPreFixtable( "manufacturer_lang" ) + "( " +;
                                 "id_manufacturer, " + ;
                                 "id_lang ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( idManufacturer ) ) + "', " + ;     // id_manufacturer
                                 "'" + ::TComercio:nLanguage + "' )"         // id_lang

   if !::commandExecDirect( cCommand )
      ::writeText( "Error al insertar el fabricante " + hGet( hManufacturer, "name" ) + " en la tabla" + ::cPreFixtable( "manufacturer_lang" ), 3 )
   end if

   // Guardo referencia a la web-----------------------------------------------

   if !empty( idManufacturer )
      ::TPrestashopId():setValueManufacturer( hget( hManufacturer, "id" ), ::getCurrentWebName(), idManufacturer )
   end if 

RETURN ( idManufacturer )

//---------------------------------------------------------------------------//

METHOD buildImagesManufacturers( hManufacturer )

   local fileTemp
   local fileImage
   local oTipoImage

   fileImage            := hget( hManufacturer, "image" )

   if !File( fileImage )
      RETURN nil
   end if

   for each oTipoImage in ::aTypeImagesPrestashop()

      if !Empty( hget( hManufacturer, "image" ) ) .and. oTipoImage:lManufactures

         if File( fileImage )

            fileTemp    := cPatTmp() + hget( hManufacturer, "cPrefijoNombre" ) + "-" + oTipoImage:cNombreTipo + ".jpg"

            saveImage( fileImage, fileTemp, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

            aadd( hget( hManufacturer, "aTypeImages" ), fileTemp )

         end if

         SysRefresh()

      end if 

   next

   fileTemp             := cPatTmp() + hget( hManufacturer, "cPrefijoNombre" ) + ".jpg"

   saveImage( fileImage, fileTemp )

   aadd( hget( hManufacturer, "aTypeImages" ), fileTemp )

RETURN nil

//---------------------------------------------------------------------------//

METHOD uploadImagesManufacturers( hManufacturer )

   local cTypeImage
   local cRemoteImage

   if !hhaskey( hManufacturer, "aTypeImages")
      RETURN ( nil )
   end if 

   for each cTypeImage in hget( hManufacturer, "aTypeImages" )

      ::meterProcesoText( "Subiendo imagen " + cTypeImage )

      ::oFtp():CreateFile( cTypeImage, ::cDirectoryManufacture() + "/" )

      SysRefresh()

      ferase( cTypeImage )

      SysRefresh()

   next

RETURN nil

//---------------------------------------------------------------------------//



