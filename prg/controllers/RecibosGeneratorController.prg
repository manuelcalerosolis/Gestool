#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosGeneratorController

   DATA oModel

   DATA hMetodoPago

   DATA oController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getMetodoPago()

   METHOD generateRecibo()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosGeneratorController

   ::oController  := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosGeneratorController

   if !empty( ::oModel )
      ::oModel:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

 METHOD generateRecibo() CLASS RecibosGeneratorController

 RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getMetodoPago() CLASS RecibosGeneratorController

   local cMetodoPago

   cMetodoPago    := ::oController:getModelBuffer( 'metodo_pago_codigo' )

   if empty( cMetodoPago )
      RETURN ( nil )
   end if 

   ::hMetodoPago   := SQLMetodoPagoModel():getBufferByCodigo( cMetodoPago )

   msgalert( ::hMetodoPago, "Hashlist")

RETURN ( ::hMetodoPago )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//