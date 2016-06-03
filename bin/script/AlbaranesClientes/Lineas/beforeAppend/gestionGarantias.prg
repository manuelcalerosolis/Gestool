#include "hbclass.ch"

#define CRLF   chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function gestionGarantias( aLine, aHeader, nView, dbfTmpLin )

Return ( TGestionGarantias():New( aLine, aHeader, nView, dbfTmpLin ):Run() )

//---------------------------------------------------------------------------//

CREATE CLASS TGestionGarantias

   DATA aLine
   DATA aHeader
   DATA nView

   DATA idProduct
   DATA idFamily

   DATA dateAlbaran
   
   DATA warrantyDays

   DATA dateWarranty

   DATA idClient

   DATA priceSale
   DATA unitsToReturn

   DATA unitsInActualLine
   DATA lastDateSale
   DATA typeSale     
   DATA clientSale   
   DATA documentSale 

   DATA cLine

   DATA maxiumnUnitsToReturnByClient

   METHOD New( aLine, aHeader, nView, dbfTmpLin )    CONSTRUCTOR

   METHOD Run()
   
   METHOD loadProductInformation()
      METHOD countProductInLines()

   METHOD searchLastSale()        
   METHOD searchLastSaleByClientWarranty()   INLINE (  ::searchLastSale( ::idClient, ::dateWarranty ) )
   METHOD searchLastSaleByClient()           INLINE (  ::searchLastSale( ::idClient, nil ) )
   METHOD searchLastSaleAnonymus()           INLINE (  ::searchLastSale( nil, ::dateWarranty ) )
   METHOD searchLastSaleUniversal()          INLINE (  ::searchLastSale( nil, nil ) )

   METHOD isEmptyDateInWarrantyPeriod()      INLINE ( empty( ::lastDateSale ) ) 
   METHOD isDateOutOfWarrantyPeriod()        INLINE ( ::isEmptyDateInWarrantyPeriod() .or. ( ::dateAlbaran - ::lastDateSale ) > ::warrantyDays )
   METHOD isDateInWarrantyPeriod()           INLINE (!( ::isDateOutOfWarrantyPeriod() ) )

   METHOD searchLastSaleAlbaranesClientes()
   METHOD searchLastSaleFacturasClientes() 
   METHOD searchLastSaleTicketsClientes() 

   METHOD validateRetrun()

   METHOD getUnitsInActualLine()                      INLINE ( ::unitsInActualLine )

   METHOD isZeroUnitsToReturn()                       INLINE ( ::unitsToReturn == 0 )

   METHOD setMaxiumnUnitsToReturnByClient( nUnits )   INLINE ( ::maxiumnUnitsToReturnByClient := nUnits )
   METHOD getMaxiumnUnitsToReturnByClient()           INLINE ( ::maxiumnUnitsToReturnByClient )

   METHOD excedMaxiumnUnitsToReturnByClient()         INLINE ( ::getUnitsInActualLine() > ::getMaxiumnUnitsToReturnByClient() )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( aLine, aHeader, nView, cLine )

   ::aLine     := aLine
   ::aHeader   := aHeader
   ::nView     := nView
   ::cLine     := cLine

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Run()
   
   local lQuestion   := .f.

   ::loadProductInformation()

   if ::getUnitsInActualLine() >= 0
      Return ( .t. )
   end if 

   ::searchLastSaleByClient() 

      if ( ::isZeroUnitsToReturn() )
         msgStop( "El el cliente " + alltrim( ::idClient ) + " no ha comprado nunca el producto " + alltrim( ::idProduct ) )
         Return .f.
      else 
         ::setMaxiumnUnitsToReturnByClient( ::unitsToReturn )
      end if 

   ::searchLastSaleByClientWarranty()

      if ( ::isEmptyDateInWarrantyPeriod() )
         msgStop( "El producto " + alltrim( ::idProduct ) + " no aparece en operaciones de venta, en el periodo de devolución, en el cliente " + alltrim( ::idClient ) + "." + CRLF + ;
                  "Se procedera a la busqueda anonima del producto." )
      end if 

      if ::isDateInWarrantyPeriod() 
         Return ( ::validateRetrun() )
      end if 

   ::searchLastSaleAnonymus()

      if !( ::isEmptyDateInWarrantyPeriod() )
      
         if ::isDateInWarrantyPeriod() .and. ::validateRetrun()
            lQuestion      := msgNoYes(   "El producto " + alltrim( ::idProduct ) + " se ha vendido en un cliente diferente a la venta actual." + CRLF + ;
                                          ""                                                                                                    + CRLF + ;
                                          "Las unidades máximas a devolver serían " + alltrim(str( ::unitsToReturn ) )                          + CRLF + ;
                                          ""                                                                                                    + CRLF + ;
                                          "¿ Desea proceder a la devolución ?", "¿ Desea proceder a la devolución ?" )
            Return ( lQuestion )
         end if 

      end if 

   ::searchLastSaleUniversal()

      if !( ::isEmptyDateInWarrantyPeriod() )

         if ( oUser():lAdministrador() )
            lQuestion      := msgNoYes(   "El producto " + alltrim( ::idProduct ) + " se ha vendido por ultima vez en la fecha " + dtoc( ::lastDateSale ) + " al cliente " + ::clientSale + " en documento " + ::typeSale + " con número " + ::documentSale + CRLF + ;
                                          "¿ Desea proceder a la devolución ?", "Atención" )
            Return ( lQuestion )
         else
            msgStop( "El producto " + alltrim( ::idProduct ) + " se ha vendido por ultima vez en la fecha " + dtoc( ::lastDateSale ) + " al cliente " + ::clientSale + " en documento " + ::typeSale + " con número " + ::documentSale, "Comuniquelo al administrador" )
         end if 
      
      end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD loadProductInformation()

   ::idProduct          := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cRef"    ) ) ]
   ::idFamily           := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cCodFam" ) ) ]
   ::unitsInActualLine  := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nUniCaja" ) ) ]

   ::dateAlbaran        := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "dFecAlb" ) ) ]
   ::idClient           := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "cCodCli" ) ) ]

   ::warrantyDays       := retFld( ::idFamily, D():Familias( ::nView ), "nDiaGrt" )

   ::dateWarranty       := ::dateAlbaran - ::warrantyDays

Return ( Self )

//---------------------------------------------------------------------------//

METHOD countProductInLines()

   local nStatus        := ( ::cLine )->( recno() )
   local nProducts      := 0

   while !( ::cLine )->( eof() )

      if ::idProduct == ( ::cLine )->cRef 
         nProducts      += ( ::cLine )->nUniCaja
      end if  

      ( ::cLine )->( dbskip() )

   end if 

   ( ::cLine )->( dbgoto( nStatus ) )

Return ( nProducts )

//---------------------------------------------------------------------------//

METHOD searchLastSale( idClient, dateWarranty ) 

   ::priceSale       := 0
   ::unitsToReturn   := 0
   ::lastDateSale    := nil

   if ( idClient == nil )
      idClient       := ""
   end if 

   if ::warrantyDays > 0

      ::searchLastSaleAlbaranesClientes( idClient, dateWarranty )

      ::searchLastSaleFacturasClientes( idClient, dateWarranty )

      ::searchLastSaleTicketsClientes( idClient, dateWarranty )

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSaleAlbaranesClientes( idClient, dateWarranty ) 

   D():getStatusAlbaranesClientesLineas( ::nView )

   D():setFocusAlbaranesClientesLineas( "cRefFec", ::nView )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::idProduct + idClient ) )  
   
      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == ::idProduct                              .and. ;
            ( empty( idClient ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli == idClient )   .and. ;
            D():AlbaranesClientesLineasNotEof( ::nView ) 

         if !( D():AlbaranesClientesLineas( ::nView ) )->lFacturado .and. ;
            ( empty( dateWarranty ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb >= dateWarranty )

            ::unitsToReturn      += ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja

            // Tenemos q probar esto ------------------------------------------

            if ( !empty( dateWarranty ) )
               ::unitsToReturn   := max( ::unitsToReturn, 0 )
            end if 

            if ( ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja > 0 ) .and. ( empty( ::lastDateSale ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb > ::lastDateSale )
               ::typeSale        := "Albaranes"
               ::clientSale      := ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli
               ::documentSale    := ( D():AlbaranesClientesLineas( ::nView ) )->cSerAlb + "/" + str( ( D():AlbaranesClientesLineas( ::nView ) )->nNumAlb )
               ::priceSale       := ( D():AlbaranesClientesLineas( ::nView ) )->nPreUnit
               ::lastDateSale    := ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb  
            end if 
         
         end if

         ( D():AlbaranesClientesLineas( ::nView ) )->( dbskip() )

      end while

   end if 

   D():setStatusAlbaranesClientesLineas( ::nView )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSaleFacturasClientes( idClient, dateWarranty ) 

   D():getStatusFacturasClientesLineas( ::nView )

   D():setFocusFacturasClientesLineas( "cRefFec", ::nView )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbseek( ::idProduct + idClient ) )  
   
      while ( D():FacturasClientesLineas( ::nView ) )->cRef == ::idProduct                                 .and. ;
            ( empty( idClient ) .or. ( D():FacturasClientesLineas( ::nView ) )->cCodCli == idClient )  .and. ;
            D():FacturasClientesLineasNotEof( ::nView ) 

         if ( empty( dateWarranty ) .or. ( D():FacturasClientesLineas( ::nView ) )->dFecFac >= dateWarranty )

            ::unitsToReturn   += ( D():FacturasClientesLineas( ::nView ) )->nUniCaja

            if ( ( D():FacturasClientesLineas( ::nView ) )->nUniCaja > 0 ) .and. ( empty( ::lastDateSale ) .or. ( D():FacturasClientesLineas( ::nView ) )->dFecFac > ::lastDateSale )
               ::typeSale     := "Facturas"
               ::clientSale   := ( D():FacturasClientesLineas( ::nView ) )->cCodCli
               ::documentSale := ( D():FacturasClientesLineas( ::nView ) )->cSerie + "/" + str( ( D():FacturasClientesLineas( ::nView ) )->nNumFac )
               ::priceSale    := ( D():FacturasClientesLineas( ::nView ) )->nPreUnit
               ::lastDateSale := ( D():FacturasClientesLineas( ::nView ) )->dFecFac  
            end if

         end if 

         ( D():FacturasClientesLineas( ::nView ) )->( dbskip() )

      end while

   end if 

   D():setStatusFacturasClientesLineas( ::nView )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSaleTicketsClientes( idClient, dateWarranty ) 

   D():getStatusTiketsLineas( ::nView )

   D():setFocusTiketsLineas( "cCbaTil", ::nView )

   if ( D():TiketsLineas( ::nView ) )->( dbseek( ::idProduct ) )  
   
      while ( D():TiketsLineas( ::nView ) )->cCbaTil == ::idProduct .and. D():TiketsLineasNotEof( ::nView ) 

         if D():gotoIdTikets( D():TiketsLineasId( ::nView ), ::nView ) 

            if ( empty( idClient ) .or. ( D():Tikets( ::nView ) )->cCliTik == idClient )

               if ( empty( dateWarranty ) .or. ( D():Tikets( ::nView ) )->dFecTik >= dateWarranty )

                  ::unitsToReturn   += ( D():TiketsLineas( ::nView ) )->nUntTil

                  if ( ( D():TiketsLineas( ::nView ) )->nUntTil > 0 ) .and. ( empty( ::lastDateSale ) .or. ( D():Tikets( ::nView ) )->dFecTik > ::lastDateSale )

                     ::typeSale     := "Ticket"
                     ::clientSale   := ( D():Tikets( ::nView ) )->cCliTik
                     ::documentSale := ( D():Tikets( ::nView ) )->cSerTik + "/" + ( D():Tikets( ::nView ) )->cNumTik 
                     ::priceSale    := nBasUTpv( ( D():TiketsLineas( ::nView ) ) )
                     ::lastDateSale := ( D():Tikets( ::nView ) )->dFecTik  
                  end if

               end if 

            end if 

         end if 

         ( D():TiketsLineas( ::nView ) )->( dbskip() )

      end while

   end if 

   D():getStatusTiketsLineas( ::nView )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validateRetrun()

   local nProducts   := ::countProductInLines()
   nProducts         += ::getUnitsInActualLine()

   msgAlert( ::countProductInLines(), "::countProductInLines()" )
   msgAlert( ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nUniCaja" ) ) ], "::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( nUniCaja ) ) ]" )

   msgAlert( abs( nProducts ), "nProducts" )
   msgAlert( ::unitsToReturn, "unitsToReturn" )
   msgAlert( ::priceSale, "priceSale" )

   if abs( nProducts ) > ::unitsToReturn

      msgStop( "Las unidades a devolver superan el número de unidades vendidas" )
      Return ( .f. )
   end if

   if ::excedMaxiumnUnitsToReturnByClient()
      msgStop( "El cliente " + alltrim( ::idClient ) + " puede devolver como máximo " + alltrim( str( ::getMaxiumnUnitsToReturnByClient() ) ) )
      Return ( .f. )
   end if 

   ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nPreUnit" ) ) ]   := ::priceSale

Return ( .t. )

//---------------------------------------------------------------------------//





