#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch"

//---------------------------------------------------------------------------//

Function CalculoComisionesAgentes( aTmp, nView )

   TCalculoComisionesAgentes():New( aTmp, nView ):Run()

Return ( nil )

//---------------------------------------------------------------------------//

CLASS TCalculoComisionesAgentes

   DATA aTmp
   DATA nView

   DATA cCodigoCliente
   DATA dAltaCliente
   DATA cNumeroPedido

   METHOD New()
   METHOD Run()
   METHOD isClienteComisionable()
   METHOD procesarLineasPedidoCliente()
      METHOD procesarLineaPedidoCliente()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( aTmp, nView )

   ::aTmp            := aTmp
   ::nView           := nView

   ::cCodigoCliente  := aTmp[ ( D():PedidosClientes( nView ) )->( fieldpos( "cCodCli" ) ) ]
   ::cNumeroPedido   := aTmp[ ( D():PedidosClientes( nView ) )->( fieldpos( "cSerPed" ) ) ]
   ::cNumeroPedido   += str( aTmp[ ( D():PedidosClientes( nView ) )->( fieldpos( "nNumPed" ) ) ], 9 )
   ::cNumeroPedido   += aTmp[ ( D():PedidosClientes( nView ) )->( fieldpos( "cSufPed" ) ) ]

   if D():gotoIdClientes( ::cCodigoCliente, nView )
      ::dAltaCliente := ( D():Clientes( nView ) )->dAlta 
   end if 

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if empty( ::dAltaCliente )
      Return ( .f. )
   end if 

   if !::isClienteComisionable()
      Return ( .f. )
   end if 

   ::procesarLineasPedidoCliente()

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD isClienteComisionable()

Return ( ::dAltaCliente > ctod( "01/01/2017" ) .and. ::dAltaCliente <= ctod( "30/06/2017" ) )

//----------------------------------------------------------------------------//

METHOD procesarLineasPedidoCliente()

   if D():gotoIdPedidosClientesLineas( ::cNumeroPedido, ::nView )

      while D():PedidosClientesLineasId( ::nView ) == ::cNumeroPedido .and. D():PedidosClientesLineasNotEof( ::nView )

         ::procesarLineaPedidoCliente()

         ( D():PedidosClientesLineas( ::nView ) )->( dbskip() )

      end while

   end if 

Return ( Self )

//----------------------------------------------------------------------------//

METHOD procesarLineaPedidoCliente()

   msgalert( ( D():PedidosClientesLineas( nView ) )->cRef, "cRef" )

Return ( Self )

//----------------------------------------------------------------------------//






