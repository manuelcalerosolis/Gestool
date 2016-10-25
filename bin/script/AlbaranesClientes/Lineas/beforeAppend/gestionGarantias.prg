#include "hbclass.ch"

#define CRLF                        chr( 13 ) + chr( 10 )

#define __default_warranty_days__   10
#define __debug_mode__              .f.

//---------------------------------------------------------------------------//

Function gestionGarantias( aLine, aHeader, nView, dbfTmpLin )

Return ( TGestionGarantias():New( aLine, aHeader, nView, dbfTmpLin ):Run() )

//---------------------------------------------------------------------------//

CREATE CLASS TGestionGarantias

   DATA aLine
   DATA aHeader
   DATA nView

   DATA idProduct
   DATA nameProduct

   DATA idFamily

   DATA dateAlbaran
   
   DATA warrantyDays

   DATA dateWarranty

   DATA idClient

   DATA priceSale

   DATA unitsToReturn
   DATA unitsToReturnClientWarranty 
   DATA unitsToReturnClient
   DATA unitsToReturnAnonymusWarranty
   DATA unitsToReturnAnonymus
   
   DATA unitsInActualLine

   DATA lastDateSale
   DATA typeSale     
   DATA clientSale   
   DATA nameSale
   DATA documentSale 

   DATA cLine

   DATA maxiumnUnitsToReturnByClient

   METHOD New( aLine, aHeader, nView, dbfTmpLin )    CONSTRUCTOR

   METHOD Run()
   
   METHOD loadProductInformation()
      METHOD countProductInLines()
      METHOD totalProductInDocument()                 INLINE ( abs( ::countProductInLines() + ::getUnitsInActualLine() ) )

   METHOD searchLastSale()        
   METHOD searchLastSaleByClientWarranty()            INLINE (  ::unitsToReturnClientWarranty   := ::searchLastSale( ::idClient, ::dateWarranty ) )
   METHOD searchLastSaleByClient()                    INLINE (  ::unitsToReturnClient           := ::searchLastSale( ::idClient, nil ) )
   METHOD searchLastSaleAnonymus()                    INLINE (  ::unitsToReturnAnonymusWarranty := ::searchLastSale( nil, ::dateWarranty ) )
   METHOD searchLastSaleUniversal()                   INLINE (  ::unitsToReturnAnonymus         := ::searchLastSale( nil, nil ) )

   METHOD isEmptyDateInWarrantyPeriod( lInfo )        INLINE ( if( istrue( lInfo ), msgalert( "Ultima fecha de venta : " + cvaltochar(::lastDateSale ), "isEmptyDateInWarrantyPeriod" ), ),;
                                                               empty( ::lastDateSale ) ) 
   METHOD isDateOutOfWarrantyPeriod()                 INLINE ( ::isEmptyDateInWarrantyPeriod() .or. ( ::dateAlbaran - ::lastDateSale ) > ::warrantyDays )
   METHOD isDateInWarrantyPeriod()                    INLINE (!( ::isDateOutOfWarrantyPeriod() ) )

   METHOD searchLastSaleAlbaranesClientes()
   METHOD searchLastSaleFacturasClientes() 
   METHOD searchLastSaleTicketsClientes() 

   METHOD validateUnitsToReturn()
   METHOD notValidateUnitsToReturn()                  INLINE ( !( ::validateUnitsToReturn() ) )

   METHOD getUnitsInActualLine()                      INLINE ( ::unitsInActualLine )

   METHOD isZeroUnitsToReturn()                       INLINE ( ::unitsToReturn == 0 )

   METHOD setMaxiumnUnitsToReturnByClient( nUnits )   INLINE ( ::maxiumnUnitsToReturnByClient := nUnits )
   METHOD getMaxiumnUnitsToReturnByClient()           INLINE ( ::maxiumnUnitsToReturnByClient )

   METHOD excedMaxiumnUnitsToReturnByClient()         INLINE ( abs( ::getUnitsInActualLine() ) > ::getMaxiumnUnitsToReturnByClient() )

   METHOD setPriceUnit()                              INLINE ( ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nPreUnit" ) ) ] := ::priceSale )

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

   // busquedas por cliente y periodo de garantia------------------------------

   ::searchLastSaleByClientWarranty()

      if ::isDateInWarrantyPeriod() .and. ::validateUnitsToReturn( __debug_mode__ )
         ::setPriceUnit()
         Return ( .t. )
      end if 

      if ( ::isEmptyDateInWarrantyPeriod( __debug_mode__ ) )
         msgInfo( "El producto " + alltrim( ::idProduct ) + " " + alltrim( ::nameProduct ) + " no aparece en operaciones de venta, en el periodo de devolución, en el cliente " + alltrim( ::idClient ) + "." + CRLF + ;
                  "Se procedera a la busqueda anonima del producto." )
      end if 

   // busquedas por cliente y sin periodo de garantia--------------------------
   // EStamos aki *****************************************************10/10/16

   ::searchLastSaleByClient() 

      if ( ::isZeroUnitsToReturn() )
         msgStop( "El cliente [" + alltrim( ::clientSale ) + " " + alltrim( ::nameSale ) + "] no ha comprado nunca el producto " + alltrim( ::idProduct ) + " " + alltrim( ::nameProduct ) )
         Return .f.
      end if 

      if ::notValidateUnitsToReturn( .t. ) 
         msgStop( "El cliente [" + alltrim( ::clientSale ) + " " + alltrim( ::nameSale ) + "] puede devolver como máximo " + alltrim( str( ::getMaxiumnUnitsToReturnByClient() ) ) + " unidades." )
         Return .f.
      end if 

   // busquedas sin cliente y con periodo de garantia--------------------------

   ::searchLastSaleAnonymus()

      if !( ::isEmptyDateInWarrantyPeriod() )
      
         if ::isDateInWarrantyPeriod() .and. ( ::unitsToReturn > 0 )
            lQuestion   := msgNoYes(   "Unidades vendidas al cliente actual en periodo de garantía es de " + cvaltochar( round( ::unitsToReturnClientWarranty, 2 ) ) + CRLF + CRLF + ;
                                       "El producto [" + alltrim( ::idProduct ) + " " + alltrim( ::nameProduct ) + "] se ha vendido en un cliente diferente a la venta actual." + CRLF + CRLF + ;
                                       "Las unidades máximas a devolver en periodo de garantía serían " + alltrim( str( round( ::unitsToReturn, 2 ) ) + " unidades." ),;
                                       "¿ Desea proceder a la devolución ?" )
            if ( lQuestion )
               ::setPriceUnit()
            end if 

            Return ( lQuestion )
         end if 

      end if 

   // busquedas sin cliente y sin periodo de garantia--------------------------

   ::searchLastSaleUniversal()

      if !( ::isEmptyDateInWarrantyPeriod() )

         if ( oUser():lAdministrador() )
            lQuestion   := msgNoYes(   "El producto [" + alltrim( ::idProduct ) + " " + alltrim( ::nameProduct ) + "] se ha vendido por ultima vez en la fecha " + dtoc( ::lastDateSale ) + CRLF + CRLF +;
                                       "Al cliente [" + alltrim( ::clientSale ) + " " + alltrim( ::nameSale ) + "]" + CRLF + CRLF + ;
                                       "Documento " + ::typeSale + " con número " + ::documentSale,;
                                       "¿ Desea proceder a la devolución ?")
            
            if ( lQuestion )
               ::setPriceUnit()
            end if 

            Return ( lQuestion )
         else
            msgStop( "El producto [" + alltrim( ::idProduct ) + " " + alltrim( ::nameProduct ) + "] se ha vendido por ultima vez en la fecha " + dtoc( ::lastDateSale ) + CRLF + CRLF +;
                     "Al cliente [" + alltrim( ::clientSale ) + " " + alltrim( ::nameSale ) + "]" + CRLF + CRLF + ;
                     "Documento " + ::typeSale + " con número " + ::documentSale,;
                     "Comuniquelo al administrador" )
         end if 
      
      end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD loadProductInformation()

   ::priceSale          := 0

   ::idProduct          := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cRef" ) ) ]
   ::nameProduct        := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cDetalle" ) ) ]
   ::idFamily           := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "cCodFam" ) ) ]
   ::unitsInActualLine  := ::aLine[ ( D():AlbaranesClientesLineas( ::nView ) )->( fieldpos( "nUniCaja" ) ) ]

   ::dateAlbaran        := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "dFecAlb" ) ) ]
   ::idClient           := ::aHeader[ ( D():AlbaranesClientes( ::nView ) )->( fieldpos( "cCodCli" ) ) ]

   ::warrantyDays       := retFld( ::idFamily, D():Familias( ::nView ), "nDiaGrt" )

   if ::warrantyDays == 0
      ::warrantyDays    := __default_warranty_days__
   end if 

   ::dateWarranty       := ::dateAlbaran - ::warrantyDays

   msgAlert( ::dateWarranty, "dateWarranty" )

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

   ::unitsToReturn   := 0
   ::lastDateSale    := nil

   if ( idClient == nil )
      idClient       := ""
   end if 

   if ::warrantyDays > 0

      ::searchLastSaleAlbaranesClientes( idClient, dateWarranty, .t. )

      ::searchLastSaleFacturasClientes( idClient, dateWarranty )

      ::searchLastSaleTicketsClientes( idClient, dateWarranty )

      ::setMaxiumnUnitsToReturnByClient( ::unitsToReturn )

   end if 

Return ( ::unitsToReturn )

//---------------------------------------------------------------------------//

METHOD searchLastSaleAlbaranesClientes( idClient, dateWarranty, lInfo ) 

   D():getStatusAlbaranesClientesLineas( ::nView )

   D():setFocusAlbaranesClientesLineas( "cRefFec", ::nView )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::idProduct + idClient ) )  

      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == ::idProduct                              .and. ;
            ( empty( idClient ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli == idClient )   .and. ;
            D():AlbaranesClientesLineasNotEof( ::nView ) 

         if !( D():AlbaranesClientesLineas( ::nView ) )->lFacturado .and. ;
            ( empty( dateWarranty ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb >= dateWarranty )

            ::unitsToReturn      += ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja

            if isTrue( lInfo )
               msgalert(   "Parametros------------------------------"         + CRLF + ;
                           "Cliente : " + cvaltochar( idClient )              + CRLF + ;
                           "Fecha garantía : " + cvaltochar( dateWarranty )   + CRLF + ;
                           "fin parametros--------------------------"         + CRLF + ;
                           "Unidades a devolver : " + str( ::unitsToReturn )  + CRLF +;
                           "Documento : " +  ( D():AlbaranesClientesLineas( ::nView ) )->cSerAlb + "/" + alltrim( str( ( D():AlbaranesClientesLineas( ::nView ) )->nNumAlb ) ) + CRLF +;
                           "Fecha en linea : " + dtoc( ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb ) )
            end if 

            // Tenemos q probar esto ------------------------------------------

            // if ( !empty( dateWarranty ) )
            //   ::unitsToReturn   := max( ::unitsToReturn, 0 )
            // end if 

            if ( ( D():AlbaranesClientesLineas( ::nView ) )->nUniCaja > 0 ) .and. ;
               ( empty( ::lastDateSale ) .or. ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb > ::lastDateSale )
               
               ::typeSale        := "Albaranes de cliente"
               ::clientSale      := ( D():AlbaranesClientesLineas( ::nView ) )->cCodCli
               ::nameSale        := retFld( ::clientSale, D():Clientes( ::nView ), "Titulo" )
               ::documentSale    := ( D():AlbaranesClientesLineas( ::nView ) )->cSerAlb + "/" + alltrim( str( ( D():AlbaranesClientesLineas( ::nView ) )->nNumAlb ) )
               ::lastDateSale    := ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb  
               
               if !empty(idClient)
                  ::priceSale    := ( D():AlbaranesClientesLineas( ::nView ) )->nPreUnit
               end if 

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
   
      while ( D():FacturasClientesLineas( ::nView ) )->cRef == ::idProduct                            .and. ;
            ( empty( idClient ) .or. ( D():FacturasClientesLineas( ::nView ) )->cCodCli == idClient ) .and. ;
            D():FacturasClientesLineasNotEof( ::nView ) 

         if ( empty( dateWarranty ) .or. ( D():FacturasClientesLineas( ::nView ) )->dFecFac >= dateWarranty )

            ::unitsToReturn   += ( D():FacturasClientesLineas( ::nView ) )->nUniCaja

            if ( ( D():FacturasClientesLineas( ::nView ) )->nUniCaja > 0 ) .and. ;
               ( empty( ::lastDateSale ) .or. ( D():FacturasClientesLineas( ::nView ) )->dFecFac > ::lastDateSale )
               
               ::typeSale     := "Facturas de clientes"
               ::clientSale   := ( D():FacturasClientesLineas( ::nView ) )->cCodCli
               ::nameSale     := retFld( ::clientSale, D():Clientes( ::nView ), "Titulo" )
               ::documentSale := ( D():FacturasClientesLineas( ::nView ) )->cSerie + "/" + alltrim( str( ( D():FacturasClientesLineas( ::nView ) )->nNumFac ) )
               ::lastDateSale := ( D():FacturasClientesLineas( ::nView ) )->dFecFac  
               
               if !empty(idClient)
                  ::priceSale := ( D():FacturasClientesLineas( ::nView ) )->nPreUnit
               end if 

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

                  if ( ( D():TiketsLineas( ::nView ) )->nUntTil > 0 ) .and. ;
                     ( empty( ::lastDateSale ) .or. ( D():Tikets( ::nView ) )->dFecTik > ::lastDateSale )

                     ::typeSale     := "Ticket de cliente"
                     ::clientSale   := ( D():Tikets( ::nView ) )->cCliTik
                     ::nameSale     := retFld( ::clientSale, D():Clientes( ::nView ), "Titulo" )
                     ::documentSale := ( D():Tikets( ::nView ) )->cSerTik + "/" + alltrim( ( D():Tikets( ::nView ) )->cNumTik )
                     ::lastDateSale := ( D():Tikets( ::nView ) )->dFecTik  
                     
                     if !empty(idClient)
                        ::priceSale := nBasUTpv( ( D():TiketsLineas( ::nView ) ) )
                     end if 

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

METHOD validateUnitsToReturn( lInfo )

   if isTrue( lInfo )
      msgAlert(   "Unidades en la linea actual : " + cvaltochar( abs( ::getUnitsInActualLine() ) )                      + CRLF +;
                  "Unidades maximas a devolver por cliente : " + cvaltochar( ::getMaxiumnUnitsToReturnByClient() )      + CRLF +;
                  "Retorno de función : " + cvaltochar( ::getMaxiumnUnitsToReturnByClient() >= abs( ::getUnitsInActualLine() ) ),;
                  "validateUnitsToReturn" )
   end if 

Return ( ::getMaxiumnUnitsToReturnByClient() >= abs( ::getUnitsInActualLine() ) )

//---------------------------------------------------------------------------//






