#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS ImportadorDocumentosLineasValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "codigo_articulo_inicio"      => {  "requiredOrEmpty"    => "El art�culo inicio es un dato requerido",;
                                                            "existArticulo"      => "El art�culo inicio {value}, no existe" },;
                        "codigo_articulo_fin"         => {  "requiredOrEmpty"    => "El art�culo fin es un dato requerido",;
                                                            "existArticulo"      => "El art�culo fin {value}, no existe" },;                                                         
                        "codigo_familia_inicio"       => {  "requiredOrEmpty"    => "La fam�lia inicio es un dato requerido",;
                                                            "existFamilia"       => "La fam�lia inicio {value}, no existe" },;
                        "codigo_familia_fin"          => {  "requiredOrEmpty"    => "La fam�lia fin es un dato requerido",;
                                                            "existFamilia"       => "La fam�lia fin {value}, no existe" },;
                        "codigo_tipo_articulo_inicio" => {  "requiredOrEmpty"    => "El tipo de art�culo inicio es un dato requerido",;
                                                            "existTipoArticulo"  => "El tipo de art�culo inicio {value}, no existe" },;
                        "codigo_tipo_articulo_fin"    => {  "requiredOrEmpty"    => "El tipo de art�culo fin es un dato requerido",;
                                                            "existTipoArticulo"  => "El tipo de art�culo fin {value}, no existe" };
                    }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

