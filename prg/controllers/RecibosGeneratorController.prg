#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosGeneratorController

   DATA oModel

   DATA oMetodoPagoModel

   DATA oPagosModel

   DATA oRecibosPagosModel

   DATA hPaymentMethod

   DATA hPaymentDays

   DATA aPaymentDays

   DATA oController

   DATA oRepository

   DATA hTotalDocument

   DATA nTermAmount 

   DATA nTotalTermAmount

   DATA nReceiptNumber

   DATA dExpirationDate 

   DATA nTotalToPaid

   DATA uuidRecibo

   DATA uuidPago 

   DATA lPositive                      INIT .t.              

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD isPaid()                     INLINE ( hget( ::hPaymentMethod, "cobrado" ) < 2 )

   METHOD getTerms()                   INLINE ( hget( ::hPaymentMethod, "numero_plazos" ) )

   METHOD isPositive()                 INLINE ( ::lPositive )
   METHOD isNegative()                 INLINE ( !::lPositive )

   METHOD getMetodoPago()

   METHOD Generate()
   METHOD GenerateNegative()           INLINE ( ::Generate( .f. ) )

   METHOD Update()
   METHOD UpdateNegative()             INLINE ( ::Update( .f. ) )

   METHOD insertRecibo( nTermAmount )

   METHOD insertPago()

   METHOD insertReciboPago()

   METHOD generatePaids()

   METHOD updatePaid()

   METHOD getController()              INLINE ( ::oController ) 
   
   METHOD isPaid()                     INLINE ( hget( ::hPaymentMethod, "cobrado" ) < 2 )

   METHOD getTerms()                   INLINE ( hget( ::hPaymentMethod, "numero_plazos" ) )

   METHOD getTotalToPay()

   METHOD getTotalDocumento()

   METHOD getConcept()

   METHOD getExpirationDate()

   METHOD getTermDays( nTerm )

   METHOD getTermAmount()

   METHOD adjustExpirationDate( dExpirationDate, aPaymentDays )

   METHOD adjustFreeMonth( hPaymentDays )

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLRecibosModel():New( self ), ), ::oModel ) 
   
   METHOD getMetodoPagoModel()         INLINE ( if( empty( ::oMetodoPagoModel ), ::oMetodoPagoModel := SQLMetodoPagoModel():New( self ), ), ::oMetodoPagoModel ) 
   
   METHOD getPagosModel()              INLINE ( if( empty( ::oPagosModel ), ::oPagosModel := SQLPagosModel():New( self ), ), ::oPagosModel ) 

   METHOD getRecibosPagosModel()       INLINE ( if( empty( ::oRecibosPagosModel ), ::oRecibosPagosModel := SQLRecibosPagosModel():New( self ), ), ::oRecibosPagosModel ) 

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := RecibosRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosGeneratorController

   ::oController                       := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosGeneratorController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oMetodoPagoModel )
      ::oMetodoPagoModel:End()
   end if

   if !empty( ::oPagosModel )
      ::oPagosModel:End()
   end if

   if !empty( ::oRecibosPagosModel )
      ::oRecibosPagosModel:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

 METHOD Generate( lPositive ) CLASS RecibosGeneratorController
   
   DEFAULT lPositive    := .t.

   ::lPositive          := lPositive

   ::nReceiptNumber     := 1

   ::nTotalTermAmount   := 0

   ::dExpirationDate    := ::oController:getModelBuffer( 'fecha' )
   
   ::nTotalToPaid       := ::getTotalToPay()

   if empty( ::nTotalToPaid )
      RETURN ( nil )
   end if 

   ::hPaymentMethod     := ::getMetodoPago()

   if empty( ::hPaymentMethod )
      RETURN ( nil )
   end if 

   ::hPaymentDays       := SQLTercerosModel():getPaymentDays( ::oController:getModelBuffer( 'tercero_codigo' ) )

   ::aPaymentDays       := {  hget( ::hPaymentDays, "primer_dia_pago" ),;
                              hget( ::hPaymentDays, "segundo_dia_pago" ),;
                              hget( ::hPaymentDays, "tercer_dia_pago" ) }
   
   ::generatePaids()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Update( lPositive ) CLASS RecibosGeneratorController
   
   DEFAULT lPositive    := .t.

   ::lPositive          := lPositive

   ::nTotalToPaid       := ::getTotalToPay()

   if empty( ::nTotalToPaid )
      RETURN ( nil )
   end if 
   
RETURN ( ::updatePaid() )

//---------------------------------------------------------------------------//

METHOD getTotalDocumento() CLASS RecibosGeneratorController

RETURN ( ::hTotalDocument  := ::getController():getRepository():getTotalesDocument( ::getController():getuuid() ) )

//---------------------------------------------------------------------------//

METHOD getTotalToPay() CLASS RecibosGeneratorController

RETURN ( ::getController():getRepository():getTotalDocument( ::getController():getuuid() ) - ::getRepository():getImporteWhereDocumentUuid( ::getController():getuuid() ) )

//---------------------------------------------------------------------------//

METHOD getMetodoPago() CLASS RecibosGeneratorController

   if empty( ::oController:getModelBuffer( 'metodo_pago_codigo' ) )
      RETURN ( nil )
   end if 

RETURN ( ::getMetodoPagoModel():getBufferByCodigo( ::oController:getModelBuffer( 'metodo_pago_codigo' ) ) )

//---------------------------------------------------------------------------//

METHOD getConcept() CLASS RecibosGeneratorController

   local cConcept

   cConcept    := "Recibo " + toSQLString( ::nReceiptNumber ) + " de " + lower( ::oController:getSubject() ) + " "
   cConcept    += alltrim( ::oController:getModelBuffer( 'serie' ) ) + "/"
   cConcept    += toSQLString( ::oController:getModelBuffer( 'numero' ) ) 
   
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
   local aPaymentDays   := {}

   hPaymentDays         := SQLTercerosModel():getPaymentDays( ::oController:getModelBuffer( 'tercero_codigo' ) )

   aPaymentDays         := { hget( hPaymentDays, "primer_dia_pago" ), hget( hPaymentDays, "segundo_dia_pago" ), hget( hPaymentDays, "tercer_dia_pago" ) }

   ::dExpirationDate    += ::getTermDays( nTerm ) 

   ::dExpirationDate    := ::adjustExpirationDate( ::dExpirationDate, ::aPaymentDays )

   ::dExpirationDate    := ::adjustFreeMonth( ::dExpirationDate, ::hPaymentDays )

RETURN ( ::dExpirationDate )

//---------------------------------------------------------------------------//

METHOD adjustExpirationDate( dExpirationDate, aPaymentDays ) CLASS RecibosGeneratorController

   local nPaymentDay

   if afirst( aPaymentDays ) == 0
      RETURN ( dExpirationDate )
   end if 

   for each nPaymentDay in aPaymentDays
      if nPaymentDay >= day( dExpirationDate )  
         RETURN ( dExpirationDate + ( nPaymentDay - day( dExpirationDate ) ) )
      end if 
   next 

RETURN ( ::adjustExpirationDate( bom( addMonth( dExpirationDate, 1 ) ), aPaymentDays ) )

//---------------------------------------------------------------------------//

METHOD adjustFreeMonth( dExpirationDate, hPaymentDays ) CLASS RecibosGeneratorController

   if cMonth( dExpirationDate ) == hget( hPaymentDays, "mes_vacaciones" )

      dExpirationDate := addMonth( dExpirationDate, 1 )

   end if

RETURN ( dExpirationDate )

//---------------------------------------------------------------------------//

METHOD getTermAmount( nTotalToPaid, nTerm ) CLASS RecibosGeneratorController
   
   local nTotalDocument

   nTotalDocument          := nTotalToPaid

   if nTerm != ::getTerms()

      ::nTermAmount        := Round( nTotalDocument / ::getTerms(), 2 )
   
      ::nTotalTermAmount   += ::nTermAmount

   else

      ::nTermAmount        := Round( nTotalDocument - ::nTotalTermAmount, 2 )

   end if

   if ::isNegative()
      ::nTermAmount        := ::nTermAmount * - 1      
   end if 
      
RETURN ( ::nTermAmount )

//---------------------------------------------------------------------------//

METHOD insertRecibo( nTotalToPaid, nTerm ) CLASS RecibosGeneratorController

   ::getModel():loadBlankBuffer()

   ::getModel():setBuffer( "importe", nTotalToPaid )

   ::getModel():setBuffer( "concepto", ::getConcept() )

   ::getModel():setBuffer( "vencimiento", ::getExpirationDate( nTerm ) )

   ::getModel():setBuffer( "parent_table", ::oController:getName() )

   ::getModel():insertBuffer()

RETURN ( ::getModel():getBuffer( "uuid" ) )

//---------------------------------------------------------------------------//

METHOD insertPago() CLASS RecibosGeneratorController

   ::getPagosModel():loadBlankBuffer()

   ::getPagosModel():setBuffer( "tercero_codigo", ::oController:getModelBuffer( 'tercero_codigo' ) )

   ::getPagosModel():setBuffer( "medio_pago_codigo", ::getMetodoPagoModel():getMedioPagoCodigo( ::oController:getModelBuffer( 'metodo_pago_codigo' ) ) )

   ::getPagosModel():setBuffer( "comentario", ::getConcept() )

   ::getPagosModel():insertBuffer()

RETURN ( ::getPagosModel():getBuffer( "uuid" ) )

//---------------------------------------------------------------------------//

METHOD insertReciboPago( nTotalToPaid ) CLASS RecibosGeneratorController

   with object ( ::getRecibosPagosModel() )

      :loadBlankBuffer()

      :setBuffer( "recibo_uuid", ::uuidRecibo )

      :setBuffer( "pago_uuid", ::uuidPago )

      :setBuffer( "importe", nTotalToPaid ) 

      :insertBuffer()

   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD generatePaids() CLASS RecibosGeneratorController

   local nTerm
   local nTotalTerm

   for nTerm := 1 to ::getTerms()

      nTotalTerm        := ::getTermAmount( ::nTotalToPaid, nTerm )
      
      ::uuidRecibo      := ::insertRecibo( nTotalTerm, nTerm )

      if ::isPaid() 

         ::uuidPago     := ::insertPago()

         ::insertReciboPago( nTotalTerm, ::uuidRecibo, ::uuidPago )

      end if 

      ::nReceiptNumber++

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updatePaid() CLASS RecibosGeneratorController
   
   local uuidRecibo     := ::getRepository():getLastNoPaidWhereDocumentUuid( ::getController():getuuid() )

   if !empty( uuidRecibo )
      ::getModel():updateFieldsWhere( { 'importe' => 'importe + ' + toSQLString( ::nTotalToPaid ) }, { 'uuid' => uuidRecibo } )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//