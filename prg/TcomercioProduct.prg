#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioProduct

   DATA  TComercio

   DATA  aIvaProduct                                        INIT {}
   DATA  aManufacturerProduct                               INIT {}
   DATA  aCategoryProduct                                   INIT {}

   METHOD New( TComercio )                                  CONSTRUCTOR

   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                                   INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                               INLINE ( ::TComercio:TPrestashopConfig )

   METHOD isSyncronizeAll()                                 INLINE ( ::TComercio:lSyncAll )

   METHOD getCurrentWebName()                               INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                                INLINE ( ::TComercio:writeText( cText ) )

   METHOD oProductDatabase()                                INLINE ( ::TComercio:oArt )
   METHOD oIvaDatabase()                                    INLINE ( ::TComercio:oIva )
   METHOD oManufacturerDatabase()                           INLINE ( ::TComercio:oFab )
   METHOD oCustomerDatabase()                               INLINE ( ::TComercio:oCli )
   METHOD oAddressDatabase()                                INLINE ( ::TComercio:oObras )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )
   METHOD oCategoryDatabase()                               INLINE ( ::TComercio:oFam )

   METHOD isProductInCurrentWeb()                           INLINE ( ::oProductDatabase():lPubInt .and. alltrim( ::oProductDatabase():cWebShop ) == ::getCurrentWebName() )  // DE MOMENTO

   METHOD buildProductInformation( idProduct )
      METHOD buildGlobalProductInformation() 
         METHOD buildIvaProduct( id )  
         METHOD buildManufacturerProduct( id )
         METHOD buildCategoryProduct( id )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioProduct

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildProductInformation( idProduct ) CLASS TComercioProduct

   if empty( idProduct )

      ::oProductDatabase():goTop()
      while !::oProductDatabase():Eof()

         if ::isProductInCurrentWeb()
            ::buildGlobalProductInformation()
         end if 

         ::oProductDatabase():Skip()

      end while

   else

      if ::oProductDatabase():Seek( idProduct ) .and. ::isProductInCurrentWeb()
         ::buildGlobalProductInformation()
      end if

   end if   

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildGlobalProductInformation() CLASS TComercioProduct

   ::writeText( alltrim( ::oProductDatabase():Codigo ) + " - " + alltrim( ::oProductDatabase():Nombre ) )

   ::buildIvaProduct(               ::oProductDatabase():TipoIva )
   ::buildManufacturerProduct(      ::oProductDatabase():cCodFab )
   ::buildCategoryProduct(          ::oProductDatabase():Familia )
   // ::buildPropiedadesPrestashop(    ::oProductDatabase():Codigo )
   // ::buildProductPrestashop(        ::oProductDatabase():Codigo )

Return ( Self )

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



