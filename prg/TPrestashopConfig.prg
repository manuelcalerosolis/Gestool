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
   METHOD getInstance()
   METHOD loadJSON() 

   METHOD getWebs()
   
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







   
