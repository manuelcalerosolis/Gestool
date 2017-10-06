#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenValidator FROM SQLBaseValidator

   METHOD New( oController )

   METHOD requiredAlmacenOrigen()

   METHOD existAlmacen()

   METHOD diferentAlmacen()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := { "almacen_origen"   => {  "requiredAlmacenOrigen"    => "El almacén origen es un dato requerido",;
                                                "existAlmacen"             => "El almacén origen no existe",;
                                                "diferentAlmacen"          => "El almacén origen debe ser distinto del almacén destino" },;
                        "almacen_destino" => {  "required"                 => "El almacén destino es un dato requerido",;
                                                "existAlmacen"             => "El almacén destino no existe",;
                                                "diferentAlmacen"          => "El almacén origen debe ser distinto del almacén destino" } } 

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD requiredAlmacenOrigen( value )

   msgalert(value, "requiredAlmacenOrigen")

   if ::oController:getModelBuffer( "tipo_movimiento" ) != __tipo_movimiento_entre_almacenes__ 
      RETURN .t.
   end if 

   if empty( value )
      RETURN .f.
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD existAlmacen( value )

RETURN ( AlmacenesModel():exist( value ) )

//---------------------------------------------------------------------------//

METHOD diferentAlmacen()

   if ::oController:getModelBuffer( "tipo_movimiento" ) != __tipo_movimiento_entre_almacenes__
      RETURN .t.
   end if 

RETURN ( ::oController:getModelBuffer( "almacen_origen" ) != ::oController:getModelBuffer( "almacen_destino" )  )

//---------------------------------------------------------------------------//
