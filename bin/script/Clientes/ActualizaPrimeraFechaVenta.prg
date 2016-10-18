#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch"

//---------------------------------------------------------------------------//

Function Actualiza( nView )

   msgrun( "Actualizando fechas de alta de clientes", "Espere por favor", {|| ActualizaPrimeraFechaVenta():New( nView ):Run() } )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ActualizaPrimeraFechaVenta

   DATA  nView

   METHOD New( nView )

   METHOD Run()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

Return ( self )

//---------------------------------------------------------------------------//
   
METHOD Run()

   local dPrimeraVentaCliente

   D():getStatusClientes( ::nView )

   ( D():Clientes( ::nView ) )->( dbgotop() )

   while !( D():Clientes( ::nView ) )->( eof() )

      if empty( ( D():Clientes( ::nView ) )->dAlta ) 

         dPrimeraVentaCliente                      := dPrimeraVentaCliente( ( D():Clientes( ::nView ) )->Cod, ::nView )

         if !empty( dPrimeraVentaCliente )
            if ( D():Clientes( ::nView ) )->( dbrlock() )
               ( D():Clientes( ::nView ) )->dAlta  := dPrimeraVentaCliente
               ( D():Clientes( ::nView ) )->( dbunlock() )
            end if 
         end if 

      end if 

      ( D():Clientes( ::nView ) )->( dbskip() )

   end while

   D():setStatusClientes( ::nView )

Return ( self )

//---------------------------------------------------------------------------//
