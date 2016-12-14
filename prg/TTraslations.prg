#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

Function getConfigTraslation( key, default )

Return ( TConfig():getInstance():getTraslation( key, default ) )

//---------------------------------------------------------------------------//

Function getConfigUser( key, default )

Return ( TConfig():getInstance():getUser( key, default ) )

//---------------------------------------------------------------------------//

Function setConfigUser( key, value )

Return ( TConfig():getInstance():setUser( key, value ) )

//---------------------------------------------------------------------------//

CLASS TConfig

   CLASSDATA oInstance
   CLASSDATA hJSON                           INIT {=>}

   DATA idEmpresa

   METHOD New()                              CONSTRUCTOR
   METHOD getInstance()
   METHOD destroyInstance()                  INLINE ( ::oInstance := nil )

   METHOD loadJSON() 
   METHOD saveJSON()

   METHOD get( node, key, default )
   METHOD getTraslation( key, default )      INLINE ( ::get( 'Traslations', key, default ) )
   METHOD getUser( key, default )            INLINE ( ::get( cCurUsr(), key, default ) )

   METHOD set( node, key, value )
   METHOD setTraslation( key, value )        INLINE ( ::set( 'Traslations', key, value ) )
   METHOD setUser( key, value )              INLINE ( ::set( cCurUsr(), key, value ) )

   METHOD getFullFileName()            

END CLASS

//---------------------------------------------------------------------------//

METHOD New( idEmpresa ) CLASS TConfig

   DEFAULT idEmpresa    := cCodEmp()

   ::idEmpresa          := idEmpresa

   ::LoadJSON()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GetInstance() CLASS TConfig

   if empty( ::oInstance )
      ::oInstance       := ::New()
   end if

RETURN ( ::oInstance )

//---------------------------------------------------------------------------//

METHOD get( node, key, default ) CLASS TConfig
   
   local hNode

   DEFAULT default   := ''

   if hhaskey( ::hJSON, node )
      hNode          := hget( ::hJSON, node )
      if hhaskey( hNode, key )
         Return ( hget( hNode, key ) )
      end if 
   end if 

   ::set( node, key, default )

Return ( default )

//---------------------------------------------------------------------------//

METHOD set( node, key, value ) CLASS TConfig
   
   local hNode

   if isnil( ::hJSON )
      Return ( .f. )
   end if 

   if hhaskey( ::hJSON, node )
      hNode       := hget( ::hJSON, node )
      if !empty( hNode )
         hset( hNode, key, value )
      end if 
   else
      hset( ::hJSON, node, { key => value } )
   end if 

   ::saveJSON()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadJSON() CLASS TConfig

   local hJSON
   local cConfig
   local cFullFileName        := ::getFullFileName()

   if file( cFullFileName )
      
      cConfig                 := memoread( cFullFileName )

      hb_jsonDecode( cConfig, @hJSON )      

      if !empty( hJSON )
         ::hJSON              := hJSON
      end if 

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SaveJSON() CLASS TConfig

   msgalert( hb_valToexp( ::hJSON), "saveJSON ")

   memowrit( ::getFullFileName(), hb_jsonencode( ::hJSON, .t. ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getFullFileName()

Return ( cPatConfig() + ::idEmpresa + "\config.json" )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

