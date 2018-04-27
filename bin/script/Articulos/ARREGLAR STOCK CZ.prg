#include "Factu.ch"

static nView
static dbfTmpAtp

//---------------------------------------------------------------------------//

function InicioHRB( nVista )

   local n     := 1

   nView       := nVista

   ( D():AlbaranesClientesLineas( nView ) )->( dbGotop() )

   while !( D():AlbaranesClientesLineas( nView ) )->( eof() )

      if ( D():AlbaranesClientesLineas( nView ) )->lFacturado != RetFld( D():AlbaranesClientesLineasId( nView ), D():AlbaranesClientes( nView ), "lFacturado" )
         if dbLock( D():AlbaranesClientesLineas( nView ) )
            ( D():AlbaranesClientesLineas( nView ) )->lFacturado := RetFld( D():AlbaranesClientesLineasId( nView ), D():AlbaranesClientes( nView ), "lFacturado" )
            ( D():AlbaranesClientesLineas( nView ) )->( dbUnlock() )
         end if
         msgwait( Str( n ), "atencion", 0.01 )
      end if

      n++

      ( D():AlbaranesClientesLineas( nView ) )->( dbSkip() )

   end while

return .t.

//---------------------------------------------------------------------------//