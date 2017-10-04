#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteRutaNavigator

   DATA cOrder
 
   DATA nProcesado                     INIT 0
   DATA aClientesRuta                  INIT {}

   DATA nView

   DATA bCondition                     

   METHOD New() 

   METHOD getClientesRutas() 
   
   METHOD setCondition( bCondition )   INLINE ( ::bCondition := bCondition )
   METHOD getCondition()               INLINE ( ::bCondition )
   METHOD evalCondition()              INLINE ( iif( !empty( ::bCondition ), eval( ::bCondition ), .t. )  )

   METHOD goto( n, oSayPosition )                    
   METHOD gotoNext( oSayPosition )     INLINE ( ::goto( ::nProcesado + 1, oSayPosition ) )
   METHOD gotoPrior( oSayPosition )    INLINE ( ::goto( ::nProcesado - 1, oSayPosition ) )

   METHOD gotoLastProcesed()

   METHOD getSelected()                INLINE ( iif( !empty( ::nProcesado ) .and. ::nProcesado >= 1 .and. ::nProcesado <= len( ::aClientesRuta ),;
                                                ::aClientesRuta[ ::nProcesado ],;
                                                space( 12 ) ) )

   METHOD msgClient()                  INLINE ( msgInfo( ( D():Clientes( ::nView ) )->Cod + "-" + ( D():Clientes( ::nView ) )->Titulo ) )
   METHOD test()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS ClienteRutaNavigator

   ::nView  := nView

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD getClientesRutas( cOrder ) CLASS ClienteRutaNavigator

   local cCodigoAgente              := AccessCode():cAgente
   local cCodigoRuta                := AccessCode():cRuta

   if cOrder == ::cOrder
      return ( ::aClientesRuta )
   end if 

   ::cOrder                         := cOrder
   ::aClientesRuta                  := {}
   ::nProcesado                     := 1

   D():getStatusClientes( ::nView )
   ( D():Clientes( ::nView ) )->( OrdSetFocus( cOrder ) )

   ( D():Clientes( ::nView ) )->( dbgotop() ) 
   while !( D():Clientes( ::nView ) )->( eof() ) 
      if ( empty( cCodigoAgente ) .or. alltrim( ( D():Clientes( ::nView ) )->cAgente ) == cCodigoAgente ) .and.;
         ( empty( cCodigoRuta ) .or. alltrim( ( D():Clientes( ::nView ) )->cCodRut ) == cCodigoRuta ) 
         aAdd( ::aClientesRuta, D():ClientesId( ::nView ) )
      end if 
      ( D():Clientes( ::nView ) )->( dbSkip() )
   end while

   D():setStatusClientes( ::nView )

Return ( ::aClientesRuta )

//---------------------------------------------------------------------------//

METHOD goto( n, oSayPosition )

   local idCliente

   if !( n >= 1 .and. n <= len( ::aClientesRuta ) )
      Return .f.
   end if 

   idCliente      := ::aClientesRuta[ n ]

   if !empty( idCliente )
      D():gotoIdClientes( idCliente, ::nView )
   end if 
      
   ::nProcesado   := n

   if !empty( oSayPosition )
      oSayPosition:setText( alltrim( str( n ) ) + "/" + alltrim( str( len( ::aClientesRuta ) ) ) )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD gotoLastProcesed( oSayPosition )  CLASS ClienteRutaNavigator

   if empty( ::aClientesRuta )
      return .f.
   end if 

   if empty( ::nProcesado )
      ::goto( 1, oSayPosition )
   else 
      ::goto( ::nProcesado, oSayPosition )
   end if 

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD test()

   ::getClientesRutas("lVisMar")

   ::gotoLastProcesed()
   ::msgClient()
   ::gotoNext()
   ::msgClient()
   ::gotoNext()
   ::msgClient()
   ::gotoPrior()
   ::msgClient()

Return ( Self )   

//---------------------------------------------------------------------------//


