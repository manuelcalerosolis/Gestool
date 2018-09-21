#include "hbclass.ch"

/*
Clase que define los methods que seran necesarios sobrecargar
para darle funcionalidad 
*/

//----------------------------------------------------------------------------//

CLASS BaseHttpService

   DATA  uValue
   DATA  lError                  INIT .f.

   METHOD New()                  CONSTRUCTOR

   METHOD getError()             INLINE ( ::lError )
   METHOD getJSON()
   METHOD getByUuid()
   METHOD findAll()
   METHOD DeleteBydId()
   METHOD Create()
   METHOD Modify()

END CLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS BaseHttpService

   ::uValue                      := {}

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD getByUuid() CLASS BaseHttpService

RETURN ( ::lError := .t.,  USetStatusCode( 501 ) )

//----------------------------------------------------------------------------//

METHOD findAll() CLASS BaseHttpService

RETURN ( ::lError := .t.,  USetStatusCode( 501 ) )

//----------------------------------------------------------------------------//

METHOD DeleteBydId() CLASS BaseHttpService

RETURN ( ::lError := .t.,  USetStatusCode( 501 ) )

//----------------------------------------------------------------------------//

METHOD Create() CLASS BaseHttpService

RETURN ( ::lError := .t.,  USetStatusCode( 501 ) )

//----------------------------------------------------------------------------//

METHOD Modify() CLASS BaseHttpService

RETURN ( ::lError := .t.,  USetStatusCode( 501 ) )

//----------------------------------------------------------------------------//

METHOD GetJSON() CLASS BaseHttpService

RETURN ( if( ::uValue != nil, hb_jsonEncode( ::uValue, .t. ), nil ) )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS ClientHttpService FROM BaseHttpService

   METHOD getByUuid()
   
   METHOD findAll() 

END CLASS

//----------------------------------------------------------------------------//

METHOD getByUuid( uuid ) CLASS ClientHttpService

   ::uValue       := SQLClientesModel():getByUuid( uuid )

RETURN ( ::uValue )

//----------------------------------------------------------------------------//

METHOD findAll() CLASS ClientHttpService
   
   ::uValue       := SQLClientesModel():findAll()

RETURN ( ::uValue )

//----------------------------------------------------------------------------//
