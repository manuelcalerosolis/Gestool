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

   METHOD New()

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

   ::uuidDelegacion        := if( hb_isnil( uuidDelegacion ), "", uuidDelegacion )
   ::codigoDelegacion      := if( hb_isnil( codigoDelegacion ), "", codigoDelegacion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getDelegacion()

   local delegacion        

   ::setDelegacion()

   delegacion              := SQLAjustableModel():getUsuarioDelegacionExclusiva( Auth():Uuid() )

   if !empty( delegacion )
      ::setDelegacion( delegacion, DelegacionesModel():getField( "cCodDlg", "Uuid", delegacion ) )
      RETURN ( self )
   end if 

   delegacion              := uFieldEmpresa( "cSufDoc" )

   if !empty( delegacion )
      ::setDelegacion( DelegacionesModel():getField( "Uuid", "cCodDlg", delegacion ), delegacion )
      RETURN ( self )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setCaja( uuidCaja, codigoCaja )

   ::uuidCaja              := if( hb_isnil( uuidCaja ), "", uuidCaja )
   ::codigoCaja            := if( hb_isnil( codigoCaja ), "", codigoCaja )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getCaja()

   local caja

   ::setCaja()
   
   caja                    := SQLAjustableModel():getUsuarioCajaExclusiva( Auth():Uuid() )
   if !empty( caja )
      ::setCaja( caja, CajasModel():getField( "cCodCaj", "Uuid", caja ) )
      RETURN ( self )
   end if 

   caja                    := uFieldEmpresa( "cDefCaj" )
   if !empty( caja )
      ::setCaja( CajasModel():getField( "Uuid", "cCodCaj", caja ), caja )
      RETURN ( self )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setAlmacen( uuidAlmacen, codigoAlmacen )

   ::uuidAlmacen           := if( hb_isnil( uuidAlmacen ), "", uuidAlmacen )
   ::codigoAlmacen         := if( hb_isnil( codigoAlmacen ), "", codigoAlmacen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getAlmacen()

   local almacen

   ::setAlmacen()
   
   almacen                 := SQLAjustableModel():getUsuarioAlmacenExclusivo( Auth():Uuid() )

   if !empty( almacen )
      ::setAlmacen( almacen, AlmacenesModel():getField( "cCodAlm", "Uuid", almacen ) )
      RETURN ( self )
   end if 

   almacen                 := uFieldEmpresa( "cDefAlm" )

   if !empty( almacen )
      ::setAlmacen( AlmacenesModel():getField( "Uuid", "cCodAlm", almacen ), almacen )
      RETURN ( self )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Application()

   if empty( oApplication )
      oApplication   := ApplicationManager():New() 
   end if

   // msgalert( oApplication:uuidAlmacen, "uuidAlmacen" )
   // msgalert( oApplication:codigoAlmacen, "codigoAlmacen" )

RETURN ( oApplication )

//---------------------------------------------------------------------------//

FUNCTION ApplicationLoad()

   if !empty( oApplication )
      oApplication   := nil
   end if

RETURN ( Application() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

