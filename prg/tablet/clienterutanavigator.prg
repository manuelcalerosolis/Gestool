#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteRutaNavigator
 
   DATA nProcesado
   DATA aClientesRuta                  INIT {}

   DATA nView

   DATA bCondition                     

   METHOD New() 

   METHOD getClientesRutas() 
   
   METHOD setCondition( bCondition )   INLINE ( ::bCondition := bCondition )
   METHOD getCondition()               INLINE ( ::bCondition )
   METHOD evalCondition()              INLINE ( iif( !empty( ::bCondition ), eval( ::bCondition ), .t. )  )

   METHOD goto( n )                    
   METHOD gotoNext()                   INLINE ( ::goto( ::nProcesado + 1 ) )
   METHOD gotoPrior()                  INLINE ( ::goto( ::nProcesado - 1 ) )

   METHOD gotoLastProcesed()

   METHOD getSelected()                INLINE ( iif( !empty( ::nProcesado ) .and. ::nProcesado >= 1 .and. ::nProcesado <= len( ::aClientesRuta ),;
                                                ::aClientesRuta[ ::nProcesado ],;
                                                "" ) )

   METHOD msgClient()                  INLINE ( msgAlert( ( D():Clientes( ::nView ) )->Cod + "-" + ( D():Clientes( ::nView ) )->Titulo ) )
   METHOD test()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS ClienteRutaNavigator

   ::nView  := nView

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD getClientesRutas( cOrder ) CLASS ClienteRutaNavigator

   local cCodigoAgente              := AccessCode():cAgente

   ::aClientesRuta                  := {}
   ::nProcesado                     := 1

   D():getStatusClientes( ::nView )
   ( D():Clientes( ::nView ) )->( OrdSetFocus( cOrder ) )

   while !( D():Clientes( ::nView ) )->( eof() ) 
      if empty( cCodigoAgente ) .or. ( D():Clientes( ::nView ) )->cAgente == cCodigoAgente
         aAdd( ::aClientesRuta, D():ClientesId( ::nView ) )
      end if 
      ( D():Clientes( ::nView ) )->( dbSkip() )
   end while

   D():setStatusClientes( ::nView )

Return ( ::aClientesRuta )

//---------------------------------------------------------------------------//

METHOD goto( n )

   local idCliente

   if !( n >= 1 .and. n <= len( ::aClientesRuta ) )
      Return .f.
   end if 

   idCliente      := ::aClientesRuta[ n ]

   if !empty( idCliente )
      D():gotoIdClientes( idCliente, ::nView )
   end if 
      
   ::nProcesado   := n

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD gotoLastProcesed()  CLASS ClienteRutaNavigator

   if empty( ::aClientesRuta )
      return .f.
   end if 

   if empty( ::nProcesado )
      ::goto( 1 )
   else 
      ::goto( ::nProcesado )
   end if 

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD test()

   ::getClientesRutas("lVisMar")

   msgAlert( hb_valtoexp( ::aClientesRuta ) )

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


