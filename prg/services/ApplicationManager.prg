#include "FiveWin.Ch"
#include "Factu.ch" 

static oApplication

//----------------------------------------------------------------------------//

CLASS ApplicationManager

   DATA uuidDelegacion     INIT ""
   DATA codigoDelegacion   INIT ""

   DATA uuidCaja           INIT ""
   DATA codigoCaja         INIT ""

   DATA uuidAlmacen        INIT ""
   DATA codigoAlmacen      INIT ""

   METHOD New() CONSTRUCTOR

   METHOD setDelegacion( uuidDelegacion, codigoDelegacion )
   METHOD getDelegacion()

   METHOD setCaja( uuidCaja, codigoCaja )
   METHOD getCaja()

   METHOD setAlmacen( uuidAlmacen, codigoAlmacen )
   METHOD getAlmacen()

END CLASS

//--------------------------------------------------------------------------//

METHOD New()

   ::getDelegacion()

   ::getCaja()

   ::getAlmacen()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setDelegacion( uuidDelegacion, codigoDelegacion )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getDelegacion()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setCaja( uuidCaja, codigoCaja )

   ::uuidCaja              := if( hb_isnil( uuidCaja ), "", uuidCaja )

   ::codigoCaja            := if( hb_isnil( codigoCaja ), "", codigoCaja )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getCaja()

   local caja

   ::setCaja()
   
   caja                    := SQLAjustableGestoolModel():getUsuarioCajaExclusiva( Auth():Uuid() )
   if !empty( caja )
      ::setCaja( caja, CajasModel():getField( "cCodCaj", "Uuid", caja ) )
      RETURN ( nil )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setAlmacen( uuidAlmacen, codigoAlmacen )

   ::uuidAlmacen           := if( hb_isnil( uuidAlmacen ), "", uuidAlmacen )

   ::codigoAlmacen         := if( hb_isnil( codigoAlmacen ), "", codigoAlmacen )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getAlmacen()

   local almacen

   ::setAlmacen()
   
   almacen                 := SQLAjustableGestoolModel():getUsuarioAlmacenExclusivo( Auth():Uuid() )

   if !empty( almacen )
      ::setAlmacen( almacen )
      RETURN ( nil )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Application()

   if empty( oApplication )
      oApplication         := ApplicationManager():New() 
   end if

RETURN ( oApplication )

//---------------------------------------------------------------------------//

FUNCTION ApplicationLoad()

   if !empty( oApplication )
      oApplication         := nil
   end if

RETURN ( Application() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

