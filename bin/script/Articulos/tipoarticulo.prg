//#include "c:\gestool\include\Factu.ch"
#include "c:\fw195\gestool\bin\include\Factu.ch"

function InicioHRB( nView )

   local cClave   := ""

   ( D():Articulos( nView ) )->( dbGoTop() )

   while !( D():Articulos( nView ) )->( Eof() )
   
      do case 

         case val( AllTrim( ( D():Articulos( nView ) )->Codigo ) ) > 0 .and. val( AllTrim( ( D():Articulos( nView ) )->Codigo ) ) < 900000
            cClave   := "0001"

         case val( AllTrim( ( D():Articulos( nView ) )->Codigo ) ) >= 900000 .and. val( AllTrim( ( D():Articulos( nView ) )->Codigo ) ) <= 999999
            cClave   := "0002"

         case Upper( SubStr( ( D():Articulos( nView ) )->Codigo, 1, 1 ) ) == "C"
            cClave   := "0003"         
         
         case Upper( SubStr( ( D():Articulos( nView ) )->Codigo, 1, 1 ) ) == "D"
            cClave   := "0004"        

         otherwise
            cClave   := "0005"

      end case

      if dbLock( D():Articulos( nView ) )
         ( D():Articulos( nView ) )->cCodTip    := cClave
         ( D():Articulos( nView ) )->( dbUnlock() )
      end if

      ( D():Articulos( nView ) )->( dbSkip() )

   end while

return .t.

//---------------------------------------------------------------------------//