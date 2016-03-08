#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TPrestashopConfig

   CLASSDATA oInstance
   CLASSDATA hConfig                   INIT {=>}

   DATA idEmpresa
   DATA hShops                         INIT {=>}
   
   METHOD New()                        CONSTRUCTOR
   METHOD GetInstance()
   METHOD LoadJSON() 

   METHOD getWebs()
   METHOD getShops( cWeb )
   METHOD getWebShop()

   METHOD setWebShopTree( oTree )
   METHOD treeToJson( oTree )
   
   METHOD getRealTimeConexion()        INLINE ( if( hhaskey( ::hConfig, "RealTimeConexion" ), hget( ::hConfig, "RealTimeConexion" ), .f. ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( idEmpresa ) CLASS TPrestashopConfig

   ::idEmpresa          := idEmpresa

Return ( Self )

//----------------------------------------------------------------//

METHOD GetInstance() CLASS TPrestashopConfig

   if empty( ::oInstance )
      ::oInstance       := ::New()
   end if

RETURN ( ::oInstance )

//---------------------------------------------------------------------------//

METHOD LoadJSON() CLASS TPrestashopConfig

   local cConfig
   local hConfig
   local cFileConfigEmpresa   := cPatConfig() + "\" + ::idEmpresa + "\" + "prestashop.json"

   if file( cFileConfigEmpresa )
      
      cConfig                 := memoread( cFileConfigEmpresa )
      hb_jsonDecode( cConfig, @hConfig )      

      if !empty( hConfig )
         ::hConfig            := hConfig
      end if 

   end if 

Return ( Self )

//----------------------------------------------------------------//

METHOD getWebs() CLASS TPrestashopConfig

   local hWebs    := {=>}

   if hhaskey( ::hConfig, "Webs" )
      hWebs       := hget( ::hConfig, "Webs" )
   end if 

Return ( hWebs )

//----------------------------------------------------------------//

METHOD getWebShop() CLASS TPrestashopConfig
   
   ::hShops       := {=>}

   heval( ::getWebs(), {|cWeb, hWeb| ::getShops( cWeb, hWeb ) } )

Return ( ::hShops )

//----------------------------------------------------------------//

METHOD getShops( cWeb, hWeb ) CLASS TPrestashopConfig

   local hShops   := hget( hWeb, "Shops")

   if !empty( hShops )
      heval( hShops, {|cKey| hset( ::hShops, cWeb + space( 1 ) + cKey, .f. ) } )
   end if 

Return ( ::hShops )

//----------------------------------------------------------------//

METHOD setWebShopTree( oTree ) CLASS TPrestashopConfig
   
   local hShops   := ::getWebShop() 

   heval( hShops, {|cKey, lValue | oTree:Add( cKey ) } )

Return ( Self )

//----------------------------------------------------------------//

METHOD treeToJson( oTree ) CLASS TPrestashopConfig

   local oItem

   for each oItem in oTree:aItems
      msgAlert( hb_valtoexp( oItem, "oItem" ) )
      msgAlert( oTree:GetCheck( oItem ), "check" )
   next

Return ( Self )

//----------------------------------------------------------------//






   
