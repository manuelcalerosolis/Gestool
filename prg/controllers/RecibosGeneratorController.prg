#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosGeneratorController

   DATA oModel

   DATA oController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getMetodoPago()

   METHOD generateRecibo()

   METHOD getPlazos( cCodigoMedioPago )

   METHOD getPlazosSentence( cCodigoMedioPago )

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

   cMetodoPago := ::oController:getModelBuffer( 'metodo_pago_codigo' )
   ::getPlazosSentence( cMetodoPago )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getPlazos( cCodigoMedioPago ) CLASS RecibosGeneratorController

   

RETURN ( nil )
//---------------------------------------------------------------------------//

METHOD getPlazosSentence( cCodigoMedioPago ) CLASS RecibosGeneratorController
local cSql

   TEXT INTO cSql

   SELECT *

   FROM %1$s AS metodos_pago

   WHERE metodos_pago.codigo = %2$s
   

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getModel():getTableName(), quoted( cCodigoMedioPago ) )
  msgalert(cSql)
RETURN ( cSql )


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//