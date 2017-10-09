#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenValidator FROM SQLBaseValidator

   METHOD New( oController )

   METHOD requiredAlmacenOrigen()

   METHOD existAlmacen()

   METHOD diferentAlmacen()

   METHOD emptyOrExistGrupoMovimiento( value )

   METHOD emptyOrExistAgente( value )

   METHOD existDivisa( value )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := { "almacen_origen"      => {  "requiredAlmacenOrigen"       => "El almac�n origen es un dato requerido",;
                                                   "existAlmacen"                => "El almac�n origen no existe",;
                                                   "diferentAlmacen"             => "El almac�n origen debe ser distinto del almac�n destino" },;
                        "almacen_destino"    => {  "required"                    => "El almac�n destino es un dato requerido",;
                                                   "existAlmacen"                => "El almac�n destino no existe",;
                                                   "diferentAlmacen"             => "El almac�n origen debe ser distinto del almac�n destino" },;
                        "grupo_movimiento"   => {  "emptyOrExistGrupoMovimiento" => "El grupo de movimiento no existe" },;
                        "agente"             => {  "emptyOrExistAgente"          => "El agente no existe" },; 
                        "divisa"             => {  "existDivisa"                 => "La divisa no existe" } } 

   ::Super:New( oController )

RETURN ( Self )

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