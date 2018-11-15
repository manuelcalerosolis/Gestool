#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD requiredAlmacenOrigen()

   METHOD existAlmacenOrigen( value )

   METHOD existAlmacen()

   METHOD diferentAlmacen()

   METHOD emptyOrExistGrupoMovimiento( value )

   METHOD emptyOrExistAgente( value )

   METHOD existDivisa( value )
 
   METHOD existNumber( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "numero"             => {  "required"                    => "El número de documento es un dato requerido",;
                                                   "numeroDocumento"             => "El número de documento no es valido" },;
                        "almacen_origen"     => {  "requiredAlmacenOrigen"       => "El almacén origen es un dato requerido",;
                                                   "existAlmacenOrigen"          => "El almacén origen no existe",;
                                                   "diferentAlmacen"             => "El almacén origen debe ser distinto del almacén destino" },;
                        "almacen_destino"    => {  "required"                    => "El almacén destino es un dato requerido",;
                                                   "existAlmacen"                => "El almacén destino no existe",;
                                                   "diferentAlmacen"             => "El almacén origen debe ser distinto del almacén destino" },;
                        "agente"             => {  "emptyOrExistAgente"          => "El agente no existe" },; 
                        "divisa"             => {  "existDivisa"                 => "La divisa no existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD requiredAlmacenOrigen( value )

   if ::oController:getModelBuffer( "tipo_movimiento" ) != __tipo_movimiento_entre_almacenes__ 
      RETURN .t.
   end if 

   if empty( value )
      RETURN .f.
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD existAlmacenOrigen( value )

   if ::oController:getModelBuffer( "tipo_movimiento" ) != __tipo_movimiento_entre_almacenes__ 
      RETURN .t.
   end if 

RETURN ( AlmacenesModel():exist( value ) )

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

METHOD emptyOrExistGrupoMovimiento( value )

   if empty( value )
      RETURN .t.
   end if 

RETURN ( GruposMovimientosModel():exist( value ) )

//---------------------------------------------------------------------------//

METHOD emptyOrExistAgente( value )

   if empty( value )
      RETURN .t.
   end if 

RETURN ( AgentesModel():exist( value ) )

//---------------------------------------------------------------------------//

METHOD existDivisa( value )

RETURN ( DivisasModel():exist( value ) )

//---------------------------------------------------------------------------//

METHOD existNumber( value )

RETURN ( .t. )

//---------------------------------------------------------------------------//

