#include "hbclass.ch"

//---------------------------------------------------------------------------//

Function gestionGarantias( aLine, aHeader, nView )

Return ( TGestionGarantias():New( aLine, aHeader, nView ):Run() )

//---------------------------------------------------------------------------//

CREATE CLASS TGestionGarantias

   DATA aLine
   DATA aHeader
   DATA nView

   DATA idProduct
   DATA idFamily
   DATA dateSale
   DATA dateOriginal
   DATA warrantyDays

   DATA idClient

   DATA priceSale
   DATA unitsSale
   DATA lastDateSale

   METHOD New( aLine, aHeader, nView )    CONSTRUCTOR

   METHOD Run()
   
   METHOD loadProductInformation()

   METHOD searchLastSale()
   METHOD searchLastSaleByClient()        INLINE ( ::searchLastSale() )
   METHOD searchLastSaleAnonymus()        INLINE ( ::idClient := nil, ::searchLastSale() )

   METHOD isEmptyDateInWarrantyPeriod()   INLINE ( empty( ::dateSale ) ) 
   METHOD isDateOutOfWarrantyPeriod()     INLINE ( ( ::dateSale - ::dateOriginal ) > ::warrantyDays )
   METHOD isDateInWarrantyPeriod()        INLINE (!( ::isDateOutOfWarrantyPeriod() ) )

   METHOD searchLastSaleAlbaranesClientes()
   METHOD searchLastSaleFacturasClientes() 
   METHOD searchLastSaleTicketsClientes() 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( aLine, aHeader, nView )

   ::aLine     := aLine
   ::aHeader   := aHeader
   ::nView     := nView

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Run()
   
   local lQuestion   := .f.

   if ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nUniCaja" ) ) ] >= 0
      Return ( Self )
   end if 
   
   ::loadProductInformation()

   ::searchLastSaleByClient()

   msgAlert( ::isEmptyDateInWarrantyPeriod(), "::isEmptyDateInWarrantyPeriod()" )
   msgAlert( ::isDateInWarrantyPeriod(), "::isDateInWarrantyPeriod()" )

   if ::isEmptyDateInWarrantyPeriod() 
      msgStop( "El producto " + alltrim( ::idProduct ) + " no aparece en operaciones de venta, en el cliente " + alltrim( ::idClient ) )
      Return ( .f. )
   end if 

   if ::isDateInWarrantyPeriod()
      Return ( .t. )
   end if 

   ::searchLastSaleAnonymus()

   if ::isEmptyDateInWarrantyPeriod() 
      Return ( .f. )
   end if 

   if ::isDateInWarrantyPeriod()
      lQuestion      := msgNoYes( "El producto " + alltrim( ::idProduct ) + " se ha vendido en un cliente diferente a la venta actual", "¿ Desea proceder a la devolución ?" )
      Return ( lQuestion )
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD loadProductInformation()

   ::idProduct    := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cRef"    ) ) ]
   ::idFamily     := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cCodFam" ) ) ]
   ::dateSale     := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "dFecAlb" ) ) ]

   ::dateOriginal := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "dFecAlb" ) ) ]
   ::idClient     := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "cCodCli" ) ) ]

   ::warrantyDays := retFld( ::idFamily, D():Familias( ::nView ), "nDiaGrt" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSale() 

   msgAlert( ::warrantyDays, "warrantyDays" )

   ::priceSale    := 0
   ::unitsSale    := 0
   ::lastDateSale := nil

   if ::warrantyDays > 0

      ::searchLastSaleAlbaranesClientes()

      ::searchLastSaleFacturasClientes()

      ::searchLastSaleTicketsClientes()

   end if 

   msgAlert( ::priceSale,        "::priceSale" )
   msgAlert( ::unitsSale,        "::unitsSale" )
   msgAlert( ::lastDateSale ,    "::lastDateSale " )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSaleAlbaranesClientes() 

   D():getStatusAlbaranesClientesLineas( ::nView )

   D():setFocusAlbaranesClientesLineas( "cRefFec", ::nView )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::idProduct + ::idClient ) )  
   
      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == ::idProduct                                 .and. ;
            ( empty( ::idClient ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli == ::idClient )  .and. ;
            D():AlbaranesClientesLineasNotEof( ::nView ) 

         if empty( ::lastDateSale ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb > ::lastDateSale
            ::unitsSale    := ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja
            ::priceSale    := ( D():AlbaranesClientesLineas( ::nView ) )->nPreUnit
            ::lastDateSale := ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb  
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

         if empty( ::lastDateSale ) .or. ( D():FacturasClientesLineas( ::nView ) )->dFecFac > ::lastDateSale
            ::unitsSale    := ( D():FacturasClientesLineas( ::nView ) )->nUniCaja
            ::priceSale    := ( D():FacturasClientesLineas( ::nView ) )->nPreUnit
            ::lastDateSale := ( D():FacturasClientesLineas( ::nView ) )->dFecFac  
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

               if empty( ::lastDateSale ) .or. ( D():Tikets( ::nView ) )->dFecTik > ::lastDateSale
                  ::unitsSale    := ( D():TiketsLineas( ::nView ) )->nUntTil
                  ::priceSale    := ( D():TiketsLineas( ::nView ) )->nPvpTil
                  ::lastDateSale := ( D():Tikets( ::nView ) )->dFecTik  
               end if

            end if 

         end if 

         ( D():TiketsLineas( ::nView ) )->( dbskip() )

      end while

   end if 

   D():getStatusTiketsLineas( ::nView )

Return ( Self )

//---------------------------------------------------------------------------//







