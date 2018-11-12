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

   DATA nPlazos
   
   DATA nDias

   DATA nImportePlazo 

   DATA nNumeroRecibo

   DATA dExpirationDate       INIT hb_date()

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

   METHOD getDias( nPlazo )

   METHOD getImportePlazo()

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

 METHOD generate() CLASS RecibosGeneratorController
   
   ::getTotalDocumento()
   
   ::nNumeroRecibo   := 1

   ::getMetodoPago()

   ::nPlazos         := hget( ::hMetodoPago, "numero_plazos" )   

   if ::isCobrado() 
      ::Insert()
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

METHOD getDias( nPlazo ) CLASS RecibosGeneratorController

   if nplazo == 1
      ::nDias :=  hget(::hMetodoPago, "primer_plazo")
      RETURN ( ::nDias )
   end if 

   if nplazo == ::nPlazos
      ::nDias :=  hget(::hMetodoPago, "ultimo_plazo")
      RETURN ( ::nDias )
   end if

   ::nDIas :=  hget(::hMetodoPago, "entre_plazo")

RETURN ( ::nDias )
//---------------------------------------------------------------------------//
METHOD getExpirationDate() CLASS RecibosGeneratorController

   ::dExpirationDate += ::nDias

RETURN( ::dExpirationDate )

//---------------------------------------------------------------------------//

METHOD getImportePlazo( nPlazo ) CLASS RecibosGeneratorController
   
   local nImporteTotal

   nImporteTotal := hget( ::hTotalesDocumento, "totalDocumento" )

   if nPlazo != ::nPlazos

      ::nImportePlazo :=  Round( nImporteTotal / ::nPlazos , 2 )
   
      msgalert( ::nImportePlazo,"importe" )
   
      RETURN( ::nImportePlazo )

   end if

   
   ::nImportePlazo :=  Round( nImporteTotal - ( ::nImportePlazo * ( ::nPlazos - 1 ) ), 2 )
      
   msgalert( ::nImportePlazo,"ultimo importe" )

RETURN( ::nImportePlazo )

//---------------------------------------------------------------------------//

METHOD Insert( nImportePlazo, dExpirationDate ) CLASS RecibosGeneratorController

   DEFAULT dExpirationDate := hb_date()

   DEFAULT nImportePlazo := hget( ::hTotalesDocumento, "totalDocumento" )

   ::getModel():loadBlankBuffer()

   ::getModel():setBuffer( "importe", nImportePlazo )

   ::getModel:setBuffer( "concepto", ::getConcepto() )

   ::getModel:setBuffer( "vencimiento", dExpirationDate )

   ::getModel:insertBuffer( ::getModel():hBuffer )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD processNoCobrado() CLASS RecibosGeneratorController

   local n

   msgalert( "no cobrado" )

   for n := 1 to ::nPlazos

   ::nDias    := ::getDias( n )

            ::Insert( ::getImportePlazo( n ), ::getExpirationDate() )
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