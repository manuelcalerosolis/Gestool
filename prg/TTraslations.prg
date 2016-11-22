#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

Function getTraslation( key )

Return ( TTraslations():getInstance():get( key ) )

//---------------------------------------------------------------------------//

CLASS TTraslations

   CLASSDATA oInstance
   CLASSDATA hTraslations              INIT {=>}

   DATA idEmpresa

   DATA cCurrentWeb 
   DATA hCurrentWeb

   METHOD New()                        CONSTRUCTOR
   METHOD getInstance()
   METHOD destroyInstance()            INLINE ( ::oInstance := nil )

   METHOD loadJSON() 
   METHOD saveJSON()

   METHOD get( key, default )
   METHOD set( key, value )

   METHOD getFullFileName()            INLINE ( cPatConfig() + ::idEmpresa + "\traslation.json" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( idEmpresa ) CLASS TTraslations

   DEFAULT idEmpresa    := cCodEmp()

   ::idEmpresa          := idEmpresa

   ::LoadJSON()

Return ( Self )

//----------------------------------------------------------------//

METHOD GetInstance() CLASS TTraslations

   if empty( ::oInstance )
      ::oInstance       := ::New()
   end if

RETURN ( ::oInstance )

//---------------------------------------------------------------------------//

METHOD get( key ) CLASS TTraslations
   
   if hhaskey( ::hTraslations, key )
      Return ( hget( ::hTraslations, key ) )
   end if 

   ::set( key, key )

   ::saveJSON()

Return ( key )

//---------------------------------------------------------------------------//

METHOD set( key, value ) CLASS TTraslations
   
   if isnil( ::hTraslations )
      Return ( .f. )
   end if 

   hset( ::hTraslations, key, value )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadJSON() CLASS TTraslations

   local cConfig
   local hTraslations
   local cFullFileName        := ::getFullFileName()

   if file( cFullFileName )
      
      cConfig                 := memoread( cFullFileName )
      hb_jsonDecode( cConfig, @hTraslations )      

      if !empty( hTraslations )
         ::hTraslations       := hTraslations
      end if 

   end if 

Return ( Self )

//----------------------------------------------------------------//

METHOD SaveJSON() CLASS TTraslations

   memowrit( ::getFullFileName(), hb_jsonencode( ::hTraslations, .t. ) )

Return ( Self )

//----------------------------------------------------------------//







   
