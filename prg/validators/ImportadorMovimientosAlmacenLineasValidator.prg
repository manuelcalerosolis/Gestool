#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "codigo_articulo_inicio"      => {  "requiredOrEmpty"    => "El artículo inicio es un dato requerido",;
                                                            "existArticulo"      => "El artículo inicio {value}, no existe" },;
                        "codigo_articulo_fin"         => {  "requiredOrEmpty"    => "El artículo fin es un dato requerido",;
                                                            "existArticulo"      => "El artículo fin {value}, no existe" },;                                                         
                        "codigo_familia_inicio"       => {  "requiredOrEmpty"    => "La família inicio es un dato requerido",;
                                                            "existFamilia"       => "La família inicio {value}, no existe" },;
                        "codigo_familia_fin"          => {  "requiredOrEmpty"    => "La família fin es un dato requerido",;
                                                            "existFamilia"       => "La família fin {value}, no existe" },;
                        "codigo_tipo_articulo_inicio" => {  "requiredOrEmpty"    => "El tipo de artículo inicio es un dato requerido",;
                                                            "existTipoArticulo"  => "El tipo de artículo inicio {value}, no existe" },;
                        "codigo_tipo_articulo_fin"    => {  "requiredOrEmpty"    => "El tipo de artículo fin es un dato requerido",;
                                                            "existTipoArticulo"  => "El tipo de artículo fin {value}, no existe" };
                    }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

