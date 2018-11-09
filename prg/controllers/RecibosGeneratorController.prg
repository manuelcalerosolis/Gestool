#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosGeneratorController

   DATA oModel

   DATA oMetodoPagoModel

   DATA hMetodoPago

   DATA oController

   DATA hTotalesDocumento

   DATA nTotalDocumento

   DATA nNumeroRecibo

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getMetodoPago()

   METHOD generate()

   METHOD Insert()

   METHOD PROCESSNoCobrado()

   METHOD getController()              INLINE ( ::oController ) 
   
   METHOD isCobrado()                  INLINE ( hget( ::hMetodoPago, "cobrado" ) < 2 )

   METHOD getTotalDocumento()

   METHOD getConcepto()

   METHOD getExpirationDate()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosModel():New( self ), ), ::oModel ) 
   
   METHOD getMetodoPagoModel()         INLINE( if( empty( ::oMetodoPagoModel ), ::oMetodoPagoModel := SQLMetodoPagoModel():New( self ), ), ::oMetodoPagoModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosGeneratorController

   ::oController     := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosGeneratorController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oMetodoPagoModel )
      ::oMetodoPagoModel:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

 METHOD generate( nTotalDocumento ) CLASS RecibosGeneratorController
   
   ::getTotalDocumento()

   DEFAULT nTotalDocumento    := hget( ::hTotalesDocumento, "totalDocumento" )
   
   ::nNumeroRecibo   := 1

   ::getMetodoPago()


   if ::isCobrado() 
      ::Insert( nTotalDocumento )
      //generar el pago
      RETURN ( nil )
   end if
   
   ::processNoCobrado()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTotalDocumento() CLASS RecibosGeneratorController

   ::hTotalesDocumento := FacturasClientesRepository():getTotal( ::getController():getuuid() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getMetodoPago() CLASS RecibosGeneratorController

   local cMetodoPago

   cMetodoPago    := ::oController:getModelBuffer( 'metodo_pago_codigo' )

   if empty( cMetodoPago )
      RETURN ( nil )
   end if 

   ::hMetodoPago   := ::getMetodoPagoModel():getBufferByCodigo( cMetodoPago )

RETURN ( ::hMetodoPago )

//---------------------------------------------------------------------------//

METHOD getConcepto() CLASS RecibosGeneratorController

   local cConcepto

   cConcepto := "Recibo " + toSQLString( ::nNumeroRecibo ) + " de la factura " 
   cConcepto +=  alltrim( ::oController:getModelBuffer( 'serie' ) ) + " - "
   cConcepto +=  toSQLString( ::oController:getModelBuffer('numero') ) 
   
RETURN ( cConcepto )

//---------------------------------------------------------------------------//

METHOD getExpirationDate( dExpirationDate ) CLASS RecibosGeneratorController


RETURN( dExpirationDate )

//---------------------------------------------------------------------------//

METHOD Insert( nTotalDocumento, dExpirationDate ) CLASS RecibosGeneratorController

   DEFAULT dExpirationDate := hb_date()

   ::getModel():loadBlankBuffer()

   ::getModel():setBuffer( "importe", nTotalDocumento )

   ::getModel:setBuffer( "concepto", ::getConcepto() )

   ::getModel:setBuffer( "vencimiento", ::getExpirationDate( dExpirationDate ) )

   ::getModel:insertBuffer( ::getModel():hBuffer )
   
RETURN ( nil )
//---------------------------------------------------------------------------//

METHOD processNoCobrado() CLASS RecibosGeneratorController

   local n
   local nPlazos
   local nPlazo
   msgalert( "no cobrado" )

   nPlazos  :=    hget( ::hMetodoPago, "numero_plazos" )

   for n := 1 to nPlazos

      if ( n = 1 )
         ::Insert( 25 )
      end if

      ::Insert( 100 )

      if ( n = nPlazos)
         ::Insert( 150 )
      end if
      msgalert( ::nNumeroRecibo,"nPlazos" )
      ::nNumeroRecibo++

   next

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//