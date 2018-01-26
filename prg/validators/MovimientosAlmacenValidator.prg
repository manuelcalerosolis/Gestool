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

   ::hValidators  := {  "numero"             => {  "required"                    => "El n�mero de documento es un dato requerido",;
                                                   "numeroDocumento"             => "El n�mero de documento no es valido" },;
                        "almacen_origen"     => {  "requiredAlmacenOrigen"       => "El almac�n origen es un dato requerido",;
                                                   "existAlmacenOrigen"          => "El almac�n origen no existe",;
                                                   "diferentAlmacen"             => "El almac�n origen debe ser distinto del almac�n destino" },;
                        "almacen_destino"    => {  "required"                    => "El almac�n destino es un dato requerido",;
                                                   "existAlmacen"                => "El almac�n destino no existe",;
                                                   "diferentAlmacen"             => "El almac�n origen debe ser distinto del almac�n destino" },;
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