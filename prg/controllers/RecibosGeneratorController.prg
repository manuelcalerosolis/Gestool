#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosGeneratorController

   DATA oModel

   DATA oMetodoPagoModel

   DATA hPaymentMethod

   DATA oController

   DATA hTotalDocument

   DATA nTermAmount 

   DATA nTotalTermAmount

   DATA nReceiptNumber

   DATA dExpirationDate                

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getMetodoPago()

   METHOD generate()

   METHOD Insert( nTermAmount, dExpirationDate )

   METHOD processNoPaid()

   METHOD getController()              INLINE ( ::oController ) 
   
   METHOD isPaid()                     INLINE ( hget( ::hPaymentMethod, "cobrado" ) < 2 )

   METHOD getTerms()                   INLINE ( hget( ::hPaymentMethod, "numero_plazos" ) )

   METHOD getTotalDocumento()

   METHOD getConcept()

   METHOD getExpirationDate()

   METHOD getTermDays( nTerm )

   METHOD getTermAmount()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLRecibosModel():New( self ), ), ::oModel ) 
   
   METHOD getMetodoPagoModel()         INLINE ( if( empty( ::oMetodoPagoModel ), ::oMetodoPagoModel := SQLMetodoPagoModel():New( self ), ), ::oMetodoPagoModel ) 

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
   
   ::nReceiptNumber     := 1

   ::nTotalTermAmount   := 0

   ::dExpirationDate    := ::oController:getModelBuffer( 'fecha' )
   
   ::getTotalDocumento()

   if empty( ::getMetodoPago() )
      RETURN ( nil )
   end if 

   if ::isPaid() 
      ::Insert()
      RETURN ( nil )
   end if
   
   ::processNoPaid()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTotalDocumento() CLASS RecibosGeneratorController

RETURN ( ::hTotalDocument  := FacturasClientesRepository():getTotal( ::getController():getuuid() ) )

//---------------------------------------------------------------------------//

METHOD getMetodoPago() CLASS RecibosGeneratorController

   if empty( ::oController:getModelBuffer( 'metodo_pago_codigo' ) )
      RETURN ( nil )
   end if 

   ::hPaymentMethod     := ::getMetodoPagoModel():getBufferByCodigo( ::oController:getModelBuffer( 'metodo_pago_codigo' ) )

RETURN ( ::hPaymentMethod )

//---------------------------------------------------------------------------//

METHOD getConcept() CLASS RecibosGeneratorController

   local cConcept

   cConcept    := "Recibo " + toSQLString( ::nReceiptNumber ) + " de la factura " 
   cConcept    +=  alltrim( ::oController:getModelBuffer( 'serie' ) ) + "/"
   cConcept    +=  toSQLString( ::oController:getModelBuffer( 'numero' ) ) 
   
RETURN ( cConcept )

//---------------------------------------------------------------------------//

METHOD getTermDays( nTerm ) CLASS RecibosGeneratorController

   if nTerm == 1
      RETURN ( hget( ::hPaymentMethod, "primer_plazo" ) )
   end if 

   if nTerm == ::getTerms() .and. hget( ::hPaymentMethod, "ultimo_plazo" ) != 0
      RETURN ( hget( ::hPaymentMethod, "ultimo_plazo" ) )
   end if

RETURN ( hget( ::hPaymentMethod, "entre_plazo" ) )

//---------------------------------------------------------------------------//

METHOD getExpirationDate( nTerm ) CLASS RecibosGeneratorController

local hPaymentDays
local dPayDay
local nPrimerDia
local nSegundoDia
local nTercerDia

   hPaymentDays := SQLClientesModel():getPaymentDays( ::oController:getModelBuffer( 'cliente_codigo' ) )
   msgalert(hb_valtoexp( hPaymentDays ), "hPaymentDays" ) 

   nPrimerDia  :=  hget( hPaymentDays, "primer_dia_pago" )   

   if nPrimerDia == 0 
      ::dExpirationDate    += ::getTermDays( nTerm )
   end if

    dPayDay       :=    Day( hb_date() + ::getTermDays( nTerm ) )
    nSegundoDia   :=    hget( hPaymentDays, "segundo_dia_pago" )
    nTercerDia    :=    hget( hPaymentDays, "tercer_dia_pago" )

   DO CASE

       CASE nPrimerDia > dPayDay
            msgalert(nPrimerDia - dPayDay)
            ::dExpirationDate += ::getTermDays( nTerm )+( nPrimerDia + dPayDay )
            msgalert( ::dExpirationDate, "primer" )

   
      CASE  nSegundoDia < dPayDay
            msgalert("segundo_dia_pago")
   
      CASE  nTercerDia < dPayDay
            msgalert("tercer_dia_pago")
   
   END CASE

RETURN ( ::dExpirationDate )

//---------------------------------------------------------------------------//

METHOD getTermAmount( nTerm ) CLASS RecibosGeneratorController
   
   local nTotalDocument

   nTotalDocument          := hget( ::hTotalDocument, "totalDocumento" )

   if nTerm != ::getTerms()

      ::nTermAmount        := Round( nTotalDocument / ::getTerms(), 2 )
   
      ::nTotalTermAmount   += ::nTermAmount

      RETURN ( ::nTermAmount )

   end if

   ::nTermAmount           := Round( nTotalDocument - ::nTotalTermAmount, 2 )
      
RETURN ( ::nTermAmount )

//---------------------------------------------------------------------------//

METHOD Insert( nTermAmount ) CLASS RecibosGeneratorController

   DEFAULT nTermAmount      := Round( hget( ::hTotalDocument, "totalDocumento" ),2 )

   ::getModel():loadBlankBuffer()

   ::getModel():setBuffer( "importe", nTermAmount )

   ::getModel():setBuffer( "concepto", ::getConcept() )

   ::getModel():setBuffer( "vencimiento", ::getExpirationDate( nTermAmount ) )

   ::getModel():insertBuffer()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD processNoPaid() CLASS RecibosGeneratorController

   local n

   for n := 1 to ::getTerms()

      ::Insert( ::getTermAmount( n ) )

      ::nReceiptNumber++

   next

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//