#include "hbclass.ch"

MEMVAR server, post, get

/* ------------------------------------------------------------------------
  Clase Base para el controlador
--------------------------------------------------------------------------*/

CLASS BaseHttpController

   DATA lError                   INIT .F.
   
   DATA oService
   
   DATA REQUEST_METHOD
   DATA CONTENT_TYPE

   DATA offset                   INIT 0
   DATA limit                    INIT 0

   METHOD new( cId )

   METHOD getByUuid( cId )
   METHOD findAll()
   METHOD deleteBydId( cId )
   METHOD create( hJSON )
   METHOD modify( hJSON )
   METHOD controller( cId )
   METHOD getJSON()
   METHOD check_content_type()   INLINE ( "application/json" $ ::CONTENT_TYPE )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cId ) CLASS BaseHttpController

   UAddHeader( "Content-Type", "application/json;charset=UTF-8" )

   if hb_isobject( ::oService ) 
      ::controller( cId )
   else
      USetStatusCode( 412 ) // Precondition Failed.
   endif

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD controller( cId ) CLASS BaseHttpController

   ::REQUEST_METHOD  := server[ "REQUEST_METHOD" ]
   ::CONTENT_TYPE    := hb_hgetdef( server, "CONTENT_TYPE", "" )  

   if ::oService:getError()
      RETURN ( nil )
   end if 

   do case
      case ::REQUEST_METHOD == "GET" .AND. empty( cId )
         ::findAll()

      case ::REQUEST_METHOD == "GET" .AND. !empty( cId )
         ::getByUuid( cId )

      case ::REQUEST_METHOD == "DELETE" .AND. !empty( cId )
         ::DeleteBydId( cId )

      case ::REQUEST_METHOD == "POST"
         if ::check_content_type()
            ::Create( hb_jsonDecode( server[ "BODY_RAW" ] ) )
         else
            USetStatusCode( 415 ) // 415 Unsupported Media Type
            ::oService:lError := .t.
         endif

      case ::REQUEST_METHOD == "PUT"
         if ::check_content_type()
            ::Modify( hb_jsonDecode( server[ "BODY_RAW" ] ) )
         else
            USetStatusCode( 415 ) // 415 Unsupported Media Type
            ::oService:lError := .t.
         endif

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getByUuid( cId ) CLASS BaseHttpController

RETURN ::oService:getByUuid( cId )

//---------------------------------------------------------------------------//

METHOD findAll() CLASS BaseHttpController

   ::offset             := Val( hb_HGetDef( GET, "offset", "0" ) )
   ::limit              := Val( hb_HGetDef( GET, "limit", "0" ) )

RETURN ::oService:findAll( ::offset, ::limit )

//---------------------------------------------------------------------------//

METHOD DeleteBydId( cId ) CLASS BaseHttpController

RETURN ::oService:DeleteBydId( cId )

//---------------------------------------------------------------------------//

METHOD Create( hJSON ) CLASS BaseHttpController

RETURN ::oService:Create( hJSON )

//---------------------------------------------------------------------------//
METHOD Modify( hJSON ) CLASS BaseHttpController

RETURN ::oService:Modify( hJSON )

//---------------------------------------------------------------------------//

METHOD getJSON() CLASS BaseHttpController

RETURN ( if( ::oService != nil, ::oService:getJSON(), nil ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/* 
Punto de Entrada
   "/v1/statusType"
   "/v1/statusType/*"
*/

//---------------------------------------------------------------------------//

CLASS ClientHttpController FROM BaseHttpController

   METHOD New( cId )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cId ) CLASS ClientHttpController

   ::oService  := ClientHttpService():New()

   ::Super:New( cId )

RETURN ( self )

//---------------------------------------------------------------------------//
