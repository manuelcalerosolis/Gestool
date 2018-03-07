#include "factu.ch"

// Campo Extra de lineas de pedidos de proveedor 
// 004 - Kilos Totales

//---------------------------------------------------------------------------//

Function afterSaveLine( nView, nMode, aTmpPed, dbfTmpLin )

   local nPos
   local hSelect
   local nDestare    := 0

   if nMode != APPD_MODE
      Return .t.
   end if

   if aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cSerPed" ) ) ] != "B"
      return .t.
   end if

   /*
   Hacemos una foto de los kilos que hay en un campo extra---------------------
   */

   D():CamposExtraLine( nView ):selectItem( if( nMode == APPD_MODE, "", Str( ( dbfTmpLin )->( OrdKeyNo() ) ) ) )

   if Empty( D():CamposExtraLine( nView ):aItemSelected )
      MsgStop( "No guardo el kilo real", "viene vacio" )
   end if

   msginfo( Hb_ValToExp( D():CamposExtraLine( nView ):aItemSelected ), "aItemSelected" )

   for each hSelect in D():CamposExtraLine( nView ):aItemSelected

      if AllTrim( hGet( hSelect, "código" ) ) == "009"
         hSet( hSelect, "valor", ( dbfTmpLin )->nUniCaja )
      end if

   next

   /*
   Hacemos los calculos del destare--------------------------------------------
   */

   if dbSeekInOrd( ( dbfTmpLin )->cRef, "Codigo", D():Articulos( nView ) )
      nDestare                   := ( ( dbfTmpLin )->nBultos * ( dbfTmpLin )->nCanPed ) * ( D():Articulos( nView ) )->NPESCAJ
      nDestare                   += ( dbfTmpLin )->nBultos * ( D():Articulos( nView ) )->NVOLCAJ
   end if

   if !Empty( ( dbfTmpLin )->cUnidad )

      do case  
         case ( dbfTmpLin )->cUnidad == "23"
            nDestare             += 23

         case ( dbfTmpLin )->cUnidad == "82"
            nDestare             += 82

	 case ( dbfTmpLin )->cUnidad == "24"
            nDestare             += 24

	case ( dbfTmpLin )->cUnidad == "21"
            nDestare             += 21

	case ( dbfTmpLin )->cUnidad == "22"
            nDestare             += 22

      end case

   end if

   if dbLock( dbfTmpLin )
      ( dbfTmpLin )->nUniCaja    := ( dbfTmpLin )->nUniCaja - nDestare
      ( dbfTmpLin )->( dbUnlock() )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//