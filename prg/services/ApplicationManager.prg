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

   METHOD getDelegacion()

   METHOD getCaja()

END CLASS

//--------------------------------------------------------------------------//

METHOD New()

   ::getDelegacion()

   ::getCaja()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getDelegacion()

   local delegacion        

   ::uuidDelegacion        := ""
   ::codigoDelegacion      := ""
   
   delegacion              := SQLAjustableModel():getUsuarioDelegacionExclusiva( Auth():Uuid() )

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

METHOD getCaja()

   local caja

   ::uuidCaja              := ""
   ::codigoCaja            := ""
   
   caja                   := SQLAjustableModel():getUsuarioCajaExclusiva( Auth():Uuid() )

   if !empty( caja )
      ::uuidCaja           := caja
      ::codigoCaja         := CajasModel():getField( "cCodCaj", "Uuid", caja )
      RETURN ( self )
   end if 

   caja                    := uFieldEmpresa( "cDefCaj" )
   if !empty( caja )
      ::codigoCaja         := caja
      ::uuidCaja           := CajasModel():getField( "Uuid", "cCodCaj", caja )
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
//---------------------------------------------------------------------------//

