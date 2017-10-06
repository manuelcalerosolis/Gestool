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

   DATA cErrorJson                     INIT ""
   
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

   METHOD getErrorJson()               INLINE ( ::cErrorJson )

   METHOD isActive()                   INLINE ( ::getFromCurrentWeb( "Active", .t. ) )
   METHOD isSilenceMode()              INLINE ( ::getFromCurrentWeb( "SilenceMode", .f. ) )
   METHOD isProcessWithoutStock()      INLINE ( ::getFromCurrentWeb( "ProcessWithoutStock", .t. ) )
   METHOD isDeleteWithoutStock()       INLINE ( ::getFromCurrentWeb( "DeleteWithoutStock", .t. ) )
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
   
   METHOD isCoverValueNull()           INLINE ( ::getFromCurrentWeb( "CoverValueNull", .f. ) )

   METHOD getOrderSerie()              INLINE ( ::getFromCurrentWeb( "OrderSerie" ) )
   METHOD getBudgetSerie()             INLINE ( ::getFromCurrentWeb( "BudgetSerie" ) )

   METHOD getDateStart()               INLINE ( ::getFromCurrentWeb( "DateStart" ) )

   METHOD getLangs()                   INLINE ( ::getFromCurrentWeb( "Langs", {} ) )
   METHOD getLang( idLang )            

   METHOD getImagesDirectory()         INLINE ( ::getValidDirectoryFtp( ::getFromCurrentWeb( "ImagesDirectory") ) )
   METHOD getValidDirectoryFtp( cDirectory )

   METHOD isRealTimeConexion()         INLINE ( if( hhaskey( ::hConfig, "RealTimeConexion" ), hget( ::hConfig, "RealTimeConexion" ), .f. ) )
   METHOD getHideExportButton()        INLINE ( if( hhaskey( ::hConfig, "HideExportButton" ), hget( ::hConfig, "HideExportButton" ), .f. ) )
   METHOD getHideHideExportButton()    INLINE ( if( hhaskey( ::hConfig, "HideExportButton" ), hget( ::hConfig, "HideExportButton" ), .f. ) )
   METHOD isInvertedNameFormat()       INLINE ( if( hhaskey( ::hConfig, "InvertedNameFormat" ), hget( ::hConfig, "InvertedNameFormat" ), .f. ) )

   METHOD getFullFileName()            INLINE ( cPatConfig() + ::idEmpresa + "\prestashop.json" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( idEmpresa ) CLASS TComercioConfig

   DEFAULT idEmpresa    := cCodEmp()

   ::idEmpresa          := idEmpresa

RETURN ( Self )

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
      RETURN ( value )
   end if 

   if hhaskey( ::getCurrentWeb(), key )
      value       := hget( ::getCurrentWeb(), key )
   end if 

RETURN ( value )

//---------------------------------------------------------------------------//

METHOD setToCurrentWeb( key, value ) CLASS TComercioConfig
   
   if empty( ::getCurrentWeb() )
      RETURN ( .f. )
   end if 

   hset( ::getCurrentWeb(), key, value )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadJSON() CLASS TComercioConfig

   local cConfig
   local hConfig
   local cFileConfigEmpresa   := ::getFullFileName()

   if !file( cFileConfigEmpresa )
      ::cErrorJson            := "Fichero " + cFileConfigEmpresa + " no encontrado"
      RETURN ( Self )
   end if 

   cConfig                    := memoread( cFileConfigEmpresa )

   hb_jsonDecode( cConfig, @hConfig )      

   if empty( hConfig )
      ::cErrorJson            := "Fichero " + cFileConfigEmpresa + " formato no valido"
   else
      ::hConfig               := hConfig
      ::cErrorJson            := "Fichero " + cFileConfigEmpresa + " cargado satisfactoriamente"
   end if 

RETURN ( Self )

//----------------------------------------------------------------//

METHOD SaveJSON() CLASS TComercioConfig

   local cConfig
   local hConfig
   local cFileConfigEmpresa   := ::getFullFileName()

   if file( cFileConfigEmpresa )
      memowrit( cFileConfigEmpresa, hb_jsonencode( ::hConfig, .t. ) )
   end if 

RETURN ( Self )

//----------------------------------------------------------------//

METHOD getWebs() CLASS TComercioConfig

   local hWebs    := {=>}

   if hhaskey( ::hConfig, "Webs" )
      hWebs       := hget( ::hConfig, "Webs" )
   end if 

RETURN ( hWebs )

//----------------------------------------------------------------//

METHOD getWebsNames() CLASS TComercioConfig

   local aWebsNames  := hgetkeys( ::getWebs() )

RETURN ( aWebsNames )

//----------------------------------------------------------------//

METHOD setCurrentWebName( cCurrentWeb ) CLASS TComercioConfig

   local hCurrentWeb

   cCurrentWeb          := alltrim( cCurrentWeb )

   if !hhaskey( ::getWebs(), cCurrentWeb )
      RETURN ( .f. )
   endif

   hCurrentWeb          := hget( ::getWebs(), cCurrentWeb )

   if empty( hCurrentWeb )
      RETURN ( .f. )
   endif
   
   ::setCurrentWeb( hCurrentWeb, cCurrentWeb )

RETURN ( .t. )

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

RETURN ( cResult )

//---------------------------------------------------------------------------//

METHOD getLang( idLang )  

   local hLang    := ::getLangs()

   idLang         := alltrim( idLang )

   if empty( hLang )
      RETURN ( "" )
   end if 

   if !hhaskey( hLang, idLang )
      RETURN ( "" )
   end if 

RETURN ( hget( hLang, idLang ) )

//---------------------------------------------------------------------------//








   
