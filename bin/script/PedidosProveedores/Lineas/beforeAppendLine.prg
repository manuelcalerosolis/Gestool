#include "factu.ch"

// Propiedad 1 Barcos   0001
// Propiedad 2 Mareas   0002

//---------------------------------------------------------------------------//

Function beforeAppendLine( aTmp, aGet, nView, nMode, lInicializate )

   local uValor

   if ( nMode != APPD_MODE )
      return .f.
   end if

   /*
   Iniciamos variables en el caso correcto-------------------------------------
   */

   if lInicializate
      inicializateHashVariables()
   end if
   

   /*
   Comprobamos e informamos la primera propiedad-------------------------------
   */

   uValor      := getVariablesToHash( "Barco" )

   if Empty( uValor )
      uValor   := brwPropiedadActual( , , Padr( "0001", 20 ) )
      setVariablesInHash( "Barco", uValor )
   end if

   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cCodPr1" ) ) ]     := Padr( "0001", 20 )
   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cValPr1" ) ) ]     := Padr( uValor, 40 )

   /*
   Comprobamos e informamos la segunda propiedad-------------------------------
   */

   uValor      := getVariablesToHash( "Marea" )

   if Empty( uValor )
      uValor   := brwPropiedadActual( , , Padr( "0002", 20 ) )
      setVariablesInHash( "Marea", uValor )
   end if

   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cCodPr2" ) ) ]     := Padr( "0002", 20 )
   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cValPr2" ) ) ]     := Padr( uValor, 40 )
   
Return ( .t. )

//---------------------------------------------------------------------------//

