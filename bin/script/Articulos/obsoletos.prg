//#include "c:\gestool\include\Factu.ch"
#include "c:\fw195\gestool\bin\include\Factu.ch"

function InicioHRB( nView )

   local cClave   := ""
   local nOrdAnt  := ( D():DetCamposExtras( nView ) )->( ordSetFocus( "cTotClave" ) )

   ( D():Articulos( nView ) )->( dbGoTop() )

   while !( D():Articulos( nView ) )->( Eof() )
   
      cClave      := "20" + "005" + ( D():Articulos( nView ) )->Codigo

      if ( D():DetCamposExtras( nView ) )->( dbSeek( cClave ) )

         msgWait( ( D():Articulos( nView ) )->Codigo + "-" + ( D():Articulos( nView ) )->Nombre, ( D():DetCamposExtras( nView ) )->cValor, 0.01 )

         if AllTrim( ( D():DetCamposExtras( nView ) )->cValor ) == "Z"
            
            if dbLock( D():Articulos( nView ) )

               ( D():Articulos( nView ) )->lObs  := .t.

               ( D():Articulos( nView ) )->( dbUnLock() )

            end if

         end if

      end if

      ( D():Articulos( nView ) )->( dbSkip() )

   end while

   ( D():DetCamposExtras( nView ) )->( ordSetFocus( nOrdAnt ) )

return .t.

//---------------------------------------------------------------------------//