#include "factu.ch"

// Propiedad 1 Barcos   0001
// Propiedad 2 Mareas   0002

//---------------------------------------------------------------------------//

Function beforeAppendLine( aTmp, aGet, nView, nMode, lInicializate, aTmpPed )

   local uValor

   if ( nMode != APPD_MODE )
      return .f.
   end if

   if Empty( aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cCtrCoste" ) ) ] )
      MsgStop( "Tiene que seleccionar un centro de coste", "¡¡Atención!!" )
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

   uValor      := getVariablesToHash( "PrimeraPropiedad" )

   if Empty( uValor )
      uValor   := oRetFld( aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cCtrCoste" ) ) ], D():CentroCoste( nView ):oDbf, "cCodPr1", "cCodigo" )
      setVariablesInHash( "PrimeraPropiedad", uValor )
   end if

   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cCodPr1" ) ) ]     := Padr( uValor, 20 )

   /*
   Comprobamos e informamos la segunda propiedad-------------------------------
   */

   uValor      := getVariablesToHash( "SegundaPropiedad" )

   if Empty( uValor )
      uValor   := oRetFld( aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cCtrCoste" ) ) ], D():CentroCoste( nView ):oDbf, "cCodPr2", "cCodigo" )
      setVariablesInHash( "SegundaPropiedad", uValor )
   end if

   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cCodPr2" ) ) ]     := Padr( uValor, 20 )


   /*
   Comprobamos e informamos valor primera propiedad-------------------------------
   */

   uValor      := getVariablesToHash( "ValorPrimeraPropiedad" )

   if Empty( uValor )
      uValor   := oRetFld( aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cCtrCoste" ) ) ], D():CentroCoste( nView ):oDbf, "cValPr1", "cCodigo" )
      setVariablesInHash( "ValorPrimeraPropiedad", uValor )
   end if

   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cValPr1" ) ) ]     := Padr( uValor, 40 )

   /*
   Comprobamos e informamos valor segunda propiedad-------------------------------
   */

   uValor      := getVariablesToHash( "ValorSegundaPropiedad" )

   if Empty( uValor )
      uValor   := oRetFld( aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cCtrCoste" ) ) ], D():CentroCoste( nView ):oDbf, "cValPr2", "cCodigo" )
      setVariablesInHash( "ValorSegundaPropiedad", uValor )
   end if

   aTmp[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "cValPr2" ) ) ]     := Padr( uValor, 40 )
   
Return ( .t. )

//---------------------------------------------------------------------------//

