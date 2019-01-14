#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PedidosVentasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPedidosVentasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PedidosVentasDescuentosController

   ::Super:New( oController )

   ::cTitle                            := "Pedidos ventas descuentos"

   ::cName                             := "pedidos_ventas_descuentos"

   ::hImage                            := {  "16" => "gc_symbol_percent_16",;
                                             "32" => "gc_symbol_percent_32",;
                                             "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PedidosVentasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPedidosVentasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cTableName                     INIT "pedidos_ventas_descuentos"

   DATA cOrderBy                       INIT "pedidos_ventas_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//