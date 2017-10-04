#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioConfig

   CLASSDATA oInstance
   CLASSDATA hConfig                   INIT {=>}

   DATA idEmpresa
   DATA hShops                         INIT {=>}

   DATA cCurrentWeb 
   DATA hCurrentWeb

   DATA aAviableProducts               INIT {}
   
   METHOD New()                        CONSTRUCTOR
   METHOD getInstance()
   METHOD destroyInstance()            INLINE ( ::oInstance := nil )

   METHOD loadJSON() 
   METHOD saveJSON()

   METHOD getWebs()
   METHOD getWebsNames()

   METHOD setCurrentWebName( cCurrentWeb )
   METHOD getCurrentWebName()          INLINE ( ::cCurrentWeb )          

   METHOD setCurrentWeb( hCurrentWeb, cCurrentWeb ) ;
                                       INLINE ( ::hCurrentWeb := hCurrentWeb, ::cCurrentWeb := cCurrentWeb )
   METHOD getCurrentWeb( hCurrentWeb ) INLINE ( ::hCurrentWeb )
   
   METHOD getFromCurrentWeb( key, default )
   METHOD setToCurrentWeb( key, value )

   METHOD isActive()                   INLINE ( ::getFromCurrentWeb( "Active", .t. ) )
   METHOD isSilenceMode()              INLINE ( ::getFromCurrentWeb( "SilenceMode", .f. ) )
   METHOD isInvertedNameFormat()       INLINE ( ::getFromCurrentWeb( "InvertedNameFormat", .f. ) )
   METHOD isProcessWithoutStock()      INLINE ( ::getFromCurrentWeb( "ProcessWithoutStock", .t. ) )
   METHOD isProcessWithoutImage()      INLINE ( ::getFromCurrentWeb( "ProcessWithoutImage", .t. ) )

   METHOD getMySqlServer()             INLINE ( ::getFromCurrentWeb( "MySqlServer" ) )
   METHOD getMySqlUser()               INLINE ( ::getFromCurrentWeb( "MySqlUser" ) )
   METHOD getMySqlPassword()           INLINE ( ::getFromCurrentWeb( "MySqlPassword" ) )
   METHOD getMySqlDatabase()           INLINE ( ::getFromCurrentWeb( "MySqlDatabase" ) )
   METHOD getMySqlPort()               INLINE ( ::getFromCurrentWeb( "MySqlPort" ) )
   METHOD getMySqlTimeOut()            INLINE ( ::getFromCurrentWeb( "MySqlTimeOut" ) )

   METHOD getStart()                   INLINE ( ::getFromCurrentWeb( "Start" ) )

   METHOD getPrefixDatabase()          INLINE ( ::getFromCurrentWeb( "PrefixDatabase" ) )

   METHOD getFtpServer()               INLINE ( ::getFromCurrentWeb( "FtpServer" ) )
   METHOD getFtpUser()                 INLINE ( ::getFromCurrentWeb( "FtpUser" ) )
   METHOD getFtpPassword()             INLINE ( ::getFromCurrentWeb( "FtpPassword" ) )
   METHOD getFtpPassive()              INLINE ( ::getFromCurrentWeb( "FtpPassive" ) )
   METHOD getFtpPort()                 INLINE ( ::getFromCurrentWeb( "FtpPort" ) )
   METHOD getFtpService()              INLINE ( ::getFromCurrentWeb( "FtpService" ) )

   METHOD getCookieKey()               INLINE ( ::getFromCurrentWeb( "CookieKey" ) )

   METHOD getStore()                   INLINE ( ::getFromCurrentWeb( "Store", "000" ) )
   METHOD getSyncronizeManufacturers() INLINE ( ::getFromCurrentWeb( "SyncronizeManufacturers", .t. ) )
   
   METHOD getOrderSerie()              INLINE ( ::getFromCurrentWeb( "OrderSerie" ) )
   METHOD getBudgetSerie()             INLINE ( ::getFromCurrentWeb( "BudgetSerie" ) )

   METHOD getDateStart()               INLINE ( ::getFromCurrentWeb( "DateStart" ) )

   METHOD getImagesDirectory()         INLINE ( ::getValidDirectoryFtp( ::getFromCurrentWeb( "ImagesDirectory") ) )
   METHOD getValidDirectoryFtp( cDirectory )

   METHOD getLangs()                   INLINE ( ::getFromCurrentWeb( "Langs" ) )

   METHOD isRealTimeConexion()         INLINE ( if( hhaskey( ::hConfig, "RealTimeConexion" ), hget( ::hConfig, "RealTimeConexion" ), .f. ) )
   METHOD getHideExportButton()        INLINE ( if( hhaskey( ::hConfig, "HideExportButton" ), hget( ::hConfig, "HideExportButton" ), .f. ) )
   METHOD getHideHideExportButton()    INLINE ( if( hhaskey( ::hConfig, "HideExportButton" ), hget( ::hConfig, "HideExportButton" ), .f. ) )

   METHOD getFullFileName()            INLINE ( cPatConfig() + ::idEmpresa + "\prestashop.json" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( idEmpresa ) CLASS TComercioConfig

   DEFAULT idEmpresa    := cCodEmp()

   ::idEmpresa          := idEmpresa

Return ( Self )

//----------------------------------------------------------------//

METHOD GetInstance() CLASS TComercioConfig

   if empty( ::oInstance )
      ::oInstance       := ::New()
   end if

RETURN ( ::oInstance )

//---------------------------------------------------------------------------//

METHOD getFromCurrentWeb( key, default ) CLASS TComercioConfig
   
   local value    := default

   if empty( ::getCurrentWeb() )
      Return ( value )
   end if 

   if hhaskey( ::getCurrentWeb(), key )
      value       := hget( ::getCurrentWeb(), key )
   end if 

Return ( value )

//---------------------------------------------------------------------------//

METHOD setToCurrentWeb( key, value ) CLASS TComercioConfig
   
   if empty( ::getCurrentWeb() )
      Return ( .f. )
   end if 

   hset( ::getCurrentWeb(), key, value )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadJSON() CLASS TComercioConfig

   local cConfig
   local hConfig
   local cFileConfigEmpresa   := ::getFullFileName()

   if file( cFileConfigEmpresa )
      
      cConfig                 := memoread( cFileConfigEmpresa )
      hb_jsonDecode( cConfig, @hConfig )      

      if !empty( hConfig )
         ::hConfig            := hConfig
      end if 

   end if 

Return ( Self )

//----------------------------------------------------------------//

METHOD SaveJSON() CLASS TComercioConfig

   local cConfig
   local hConfig
   local cFileConfigEmpresa   := ::getFullFileName()

   if file( cFileConfigEmpresa )
      memowrit( cFileConfigEmpresa, hb_jsonencode( ::hConfig, .t. ) )
   end if 

Return ( Self )

//----------------------------------------------------------------//

METHOD getWebs() CLASS TComercioConfig

   local hWebs    := {=>}

   if hhaskey( ::hConfig, "Webs" )
      hWebs       := hget( ::hConfig, "Webs" )
   end if 

Return ( hWebs )

//----------------------------------------------------------------//

METHOD getWebsNames() CLASS TComercioConfig

   local aWebsNames  := hgetkeys( ::getWebs() )

Return ( aWebsNames )

//----------------------------------------------------------------//

METHOD setCurrentWebName( cCurrentWeb ) CLASS TComercioConfig

   local hCurrentWeb

   if !hhaskey( ::getWebs(), cCurrentWeb )
      Return ( .f. )
   endif

   hCurrentWeb          := hget( ::getWebs(), cCurrentWeb )

   if empty( hCurrentWeb )
      Return ( .f. )
   endif
   
   ::setCurrentWeb( hCurrentWeb, cCurrentWeb )

Return ( .t. )

//----------------------------------------------------------------//

METHOD getValidDirectoryFtp( cDirectory ) CLASS TComercioConfig

   local cResult

   /*
   Cambiamos todas las contrabarras por barras normales------------------------
   */

   cResult     := StrTran( alltrim( cDirectory ), "\", "/" )

   /*
   Si empieza por barra la quitamos--------------------------------------------
   */

   if Left( cResult, 1 ) == "/"
      cResult  := Substr( cResult, 2 )
   end if

   /*
   Si termina por barra la quitamos--------------------------------------------
   */

   if Right( cResult, 1 ) == "/"
      cResult  := Substr( cResult, 1, Len( cResult ) - 1 )
   end if

Return ( cResult )

//---------------------------------------------------------------------------//






   
