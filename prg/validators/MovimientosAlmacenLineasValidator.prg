#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasValidator FROM SQLBaseValidator

   METHOD New( oController )

   METHOD existArticulo( value )       INLINE ( ArticulosModel():exist( value ) )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := {  "codigo_articulo"    => {  "required"        => "El art�culo es un dato requerido",;
                                                   "existArticulo"   => "El art�culo no existe" },;
                        "nombre_articulo"    => {  "required"        => "El nombre del art�culo es un dato requerido" }                                                    }

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//


