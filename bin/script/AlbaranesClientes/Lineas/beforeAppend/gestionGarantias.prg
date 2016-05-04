#include "hbclass.ch"

//---------------------------------------------------------------------------//

Function gestionGarantias( aLine, aHeader, nView )

   local oGestionGarantia  := ExportacionAlbaranes():New( aLine, aHeader, nView )
   oGestionGarantia:Run()

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ExportacionAlbaranes

   DATA aLine
   DATA aHeader
   DATA nView

   DATA idProduct
   DATA idFamily
   DATA dateSale
   DATA warrantyDays

   DATA idClient

   DATA priceSale
   DATA unitsSale
   DATA lastDateSale

   METHOD New( aLine, aHeader, nView )  CONSTRUCTOR

   METHOD Run()
   
   METHOD loadProductInformation()

   METHOD searchLastSale()

   METHOD searchLastSaleAlbaranesClientes()
   METHOD searchLastSaleFacturasClientes() 
   METHOD searchLastSaleTicketsClientes() 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( aLine, aHeader, nView ) CLASS ExportacionAlbaranes

   ::aLine     := aLine
   ::aHeader   := aHeader
   ::nView     := nView

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Run()

   if ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nUniCaja" ) ) ] < 0

      ::loadProductInformation()

      ::searchLastSale()

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadProductInformation()

   ::idProduct    := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cRef"    ) ) ]
   ::idFamily     := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cCodFam" ) ) ]
   ::dateSale     := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "dFecAlb" ) ) ]

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

   msgAlert( ::priceSale, "::priceSale" )
   msgAlert( ::unitsSale, "::unitsSale" )
   msgAlert( ::lastDateSale , "::lastDateSale " )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD searchLastSaleAlbaranesClientes() 

   D():getStatusAlbaranesClientesLineas( ::nView )

   D():setFocusAlbaranesClientesLineas( "cRefFec", ::nView )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::idProduct + ::idClient ) )  
   
      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == ::idProduct                                 .and. ;
            ( empty( ::idClient ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli == ::idClient )  .and. ;
            D():AlbaranClientesLineasNotEof( ::nView ) 

         if empty( ::lastDateSale ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb < ::lastDateSale
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
// TODO

METHOD searchLastSaleFacturasClientes() 

   D():getStatusAlbaranesClientesLineas( ::nView )

   D():setFocusAlbaranesClientesLineas( "cRefFec", ::nView )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::idProduct + ::idClient ) )  
   
      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == ::idProduct                                 .and. ;
            ( empty( ::idClient ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli == ::idClient )  .and. ;
            D():AlbaranClientesLineasNotEof( ::nView ) 

         if empty( ::lastDateSale ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb < ::lastDateSale
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
// TODO

METHOD searchLastSaleTicketsClientes() 

   D():getStatusAlbaranesClientesLineas( ::nView )

   D():setFocusAlbaranesClientesLineas( "cRefFec", ::nView )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::idProduct + ::idClient ) )  
   
      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == ::idProduct                                 .and. ;
            ( empty( ::idClient ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli == ::idClient )  .and. ;
            D():AlbaranClientesLineasNotEof( ::nView ) 

         if empty( ::lastDateSale ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb < ::lastDateSale
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







