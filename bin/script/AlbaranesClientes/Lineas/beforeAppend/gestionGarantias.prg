#include "hbclass.ch"

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
   DATA unitsSale
   DATA lastDateSale
   DATA typeSale     
   DATA clientSale   
   DATA documentSale 

   DATA cLine

   METHOD New( aLine, aHeader, nView, dbfTmpLin )    CONSTRUCTOR

   METHOD Run()
   
   METHOD loadProductInformation()
      METHOD countProductInLines()

   METHOD searchLastSaleByClient()        
   METHOD searchLastSaleAnonymus()        INLINE ( ::idClient := "",       ::searchLastSaleByClient() )
   METHOD searchLastSaleUniversal()       INLINE ( ::dateWarranty := nil,  ::searchLastSaleAnonymus() )

   METHOD isEmptyDateInWarrantyPeriod()   INLINE ( empty( ::lastDateSale ) ) 
   METHOD isDateOutOfWarrantyPeriod()     INLINE ( ::isEmptyDateInWarrantyPeriod() .or. ( ::dateAlbaran - ::lastDateSale ) > ::warrantyDays )
   METHOD isDateInWarrantyPeriod()        INLINE (!( ::isDateOutOfWarrantyPeriod() ) )

   METHOD searchLastSaleAlbaranesClientes()
   METHOD searchLastSaleFacturasClientes() 
   METHOD searchLastSaleTicketsClientes() 

   METHOD validateSale()

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

   if ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nUniCaja" ) ) ] >= 0
      Return ( .t. )
   end if 

   ::loadProductInformation()

   ::searchLastSaleByClient()

      if ::isEmptyDateInWarrantyPeriod() 
         msgStop( "El producto " + alltrim( ::idProduct ) + " no aparece en operaciones de venta, en el periodo de devolución, en el cliente " + alltrim( ::idClient ) + "." + CRLF + ;
                  "Se procedera a la busqueda anonima del producto." )
      end if 

      if ::isDateInWarrantyPeriod() 
         Return ( ::validateSale() )
      end if 

   ::searchLastSaleAnonymus()

      if !( ::isEmptyDateInWarrantyPeriod() )
      
         if ::isDateInWarrantyPeriod() .and. ::validateSale()
            lQuestion      := msgNoYes(   "El producto " + alltrim( ::idProduct ) + " se ha vendido en un cliente diferente a la venta actual" + CRLF + ;
                                          "¿ Desea proceder a la devolución ?", "Atención" )
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

   ::idProduct       := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cRef"    ) ) ]
   ::idFamily        := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cCodFam" ) ) ]

   ::dateAlbaran     := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "dFecAlb" ) ) ]
   ::idClient        := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "cCodCli" ) ) ]

   ::warrantyDays    := retFld( ::idFamily, D():Familias( ::nView ), "nDiaGrt" )

   ::dateWarranty    := ::dateAlbaran - ::warrantyDays

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

METHOD searchLastSaleByClient() 

   ::priceSale       := 0
   ::unitsSale       := 0
   ::lastDateSale    := nil

   if ::warrantyDays > 0

      ::searchLastSaleAlbaranesClientes()

      ::searchLastSaleFacturasClientes()

      ::searchLastSaleTicketsClientes()

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSaleAlbaranesClientes() 

   D():getStatusAlbaranesClientesLineas( ::nView )

   D():setFocusAlbaranesClientesLineas( "cRefFec", ::nView )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::idProduct + ::idClient ) )  
   
      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == ::idProduct                                 .and. ;
            ( empty( ::idClient ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli == ::idClient )  .and. ;
            D():AlbaranesClientesLineasNotEof( ::nView ) 

         if !( D():AlbaranesClientesLineas( ::nView ) )->lFacturado .and. ( empty( ::dateWarranty ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb >= ::dateWarranty )

            ::unitsSale       += ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja

            if ( ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja > 0 ) .and. ( empty( ::lastDateSale ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb > ::lastDateSale )
               ::typeSale     := "Albaranes"
               ::clientSale   := ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli
               ::documentSale := ( D():AlbaranesClientesLineas( ::nView ) )->cSerAlb + "/" + str( ( D():AlbaranesClientesLineas( ::nView ) )->nNumAlb )
               ::priceSale    := ( D():AlbaranesClientesLineas( ::nView ) )->nPreUnit
               ::lastDateSale := ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb  
            end if 
         
         end if

         ( D():AlbaranesClientesLineas( ::nView ) )->( dbskip() )

      end while

   end if 

   D():setStatusAlbaranesClientesLineas( ::nView )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSaleFacturasClientes() 

   D():getStatusFacturasClientesLineas( ::nView )

   D():setFocusFacturasClientesLineas( "cRefFec", ::nView )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbseek( ::idProduct + ::idClient ) )  
   
      while ( D():FacturasClientesLineas( ::nView ) )->cRef == ::idProduct                                 .and. ;
            ( empty( ::idClient ) .or. ( D():FacturasClientesLineas( ::nView ) )->cCodCli == ::idClient )  .and. ;
            D():FacturasClientesLineasNotEof( ::nView ) 

         if ( empty( ::dateWarranty ) .or. ( D():FacturasClientesLineas( ::nView ) )->dFecFac >= ::dateWarranty )

            ::unitsSale       += ( D():FacturasClientesLineas( ::nView ) )->nUniCaja

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

METHOD searchLastSaleTicketsClientes() 

   D():getStatusTiketsLineas( ::nView )

   D():setFocusTiketsLineas( "cCbaTil", ::nView )

   if ( D():TiketsLineas( ::nView ) )->( dbseek( ::idProduct ) )  
   
      while ( D():TiketsLineas( ::nView ) )->cCbaTil == ::idProduct .and. D():TiketsLineasNotEof( ::nView ) 

         if D():gotoIdTikets( D():TiketsLineasId( ::nView ), ::nView ) 

            if ( empty( ::idClient ) .or. ( D():Tikets( ::nView ) )->cCliTik == ::idClient )

               if ( empty( ::dateWarranty ) .or. ( D():Tikets( ::nView ) )->dFecTik >= ::dateWarranty )

                  ::unitsSale       += ( D():TiketsLineas( ::nView ) )->nUntTil

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

METHOD validateSale()

   local nProducts   := ::countProductInLines()
   nProducts         += ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nUniCaja" ) ) ] 

   msgAlert( abs( nProducts ), "nProducts" )
   msgAlert( ::unitsSale, "unitsSale" )
   msgAlert( ::priceSale, "priceSale" )

   if abs( nProducts ) >= ::unitsSale
      msgStop( "Las unidades a devolver superan el número de unidades vendidas" )
      Return ( .f. )
   end if

   ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nPreUnit" ) ) ]   := ::priceSale

Return ( .t. )

//---------------------------------------------------------------------------//





