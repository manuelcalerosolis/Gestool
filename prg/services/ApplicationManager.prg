#include "FiveWin.Ch"
#include "Factu.ch" 

static oApplication

//----------------------------------------------------------------------------//

CLASS ApplicationManager

   DATA uuidDelegacion     INIT ""
   DATA codigoDelegacion   INIT ""

   DATA uuidCaja           INIT ""
   DATA codigoCaja         INIT ""

   METHOD New()

   METHOD setDelegacion()

   METHOD setCaja()

END CLASS

//--------------------------------------------------------------------------//

METHOD New()

   ::setDelegacion()

   ::setCaja()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setDelegacion()

   local delegacion        := SQLAjustableModel():getUsuarioDelegacionExclusiva( Auth():Uuid() )

   if !empty( delegacion )
      ::uuidDelegacion     := delegacion
      ::codigoDelegacion   := DelegacionesModel():getField( "cCodDlg", "Uuid", delegacion )
      RETURN ( self )
   end if 

   delegacion              := uFieldEmpresa( "cSufDoc" )
   if !empty( delegacion )
      ::codigoDelegacion   := delegacion
      ::uuidDelegacion     := DelegacionesModel():getField( "Uuid", "cCodDlg", delegacion )
      RETURN ( self )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setCaja()

   local cajas             := SQLAjustableModel():getUsuarioCajaExclusiva( Auth():Uuid() )

   if !empty( cajas )
      ::uuidCajas          := cajas
      ::codigoCajas        := CajasModel():getField( "cCodCaj", "Uuid", cajas )
      RETURN ( self )
   end if 

   cajas                   := uFieldEmpresa( "cDefCaj" )
   if !empty( Cajas )
      ::codigoCajas        := cajas
      ::uuidCajas          := CajasesModel():getField( "Uuid", "cCodCaj", cajas )
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

