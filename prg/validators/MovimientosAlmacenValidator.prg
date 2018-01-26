#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD numeroDocumento( value )

   METHOD requiredAlmacenOrigen()

   METHOD existAlmacenOrigen( value )

   METHOD existAlmacen()

   METHOD diferentAlmacen()

   METHOD emptyOrExistGrupoMovimiento( value )

   METHOD emptyOrExistAgente( value )

   METHOD existDivisa( value )
 
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
                        "grupo_movimiento"   => {  "emptyOrExistGrupoMovimiento" => "El grupo de movimiento no existe" },;
                        "agente"             => {  "emptyOrExistAgente"          => "El agente no existe" },; 
                        "divisa"             => {  "existDivisa"                 => "La divisa no existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD numeroDocumento( value )

   local nAt
   local cSerie   := ""
   local nNumero

   value          := alltrim( value )

   nAt            := rat( "/", value )
   if nAt != 0
      nNumero     := substr( value, nAt + 1 )
      cSerie      := substr( value, 1, nAt  )
   else
      nNumero     := value
   end if  

   if !hb_regexlike( "^[0-9]{1,6}$", nNumero )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

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