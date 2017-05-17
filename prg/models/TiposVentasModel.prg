#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasModel FROM SQLBaseModel

   DATA cTableName                           INIT "tipos_ventas"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD arrayTiposVentas()

   METHOD existTiposVentas( cValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "tipos_ventas"

   ::cDbfTableName				 	:= "TVTA"

   ::hColumns                   	:= {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                         "text"		=> "Identificador"                        ,;
   															         "dbfField" 	=> ""}                                    ,;
                                       "codigo"    => {  "create"    => "VARCHAR( 2 )"                         ,;
                                                         "text"      => "Código de identificación en DBF"      ,; 
                                                         "dbfField"  => "CCODMOV"}                             ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 20 ) NOT NULL"               ,;
   															         "text"		=> "Descripción del movimiento"           ,;
   															         "dbfField" 	=> "CDESMOV"}                             ,;
                                       "unidades"  => {  "create"    => "INTEGER"                              ,;   
                                                         "text"      => "Comportamiento en unidades"           ,;
                                                         "dbfField"  => "NUNDMOV"}                             ,;
                                       "importes"  => {  "create"    => "INTEGER"                              ,;
                                                         "text"      => "Comportamiento del precio"            ,;   
                                                         "dbfField"  => "NIMPMOV"}                             }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposVentas()

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aResult                 := ::selectFetchArray( cSentence ) 

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD existTiposVentas( cValue )

   local cSentence               := "SELECT nombre FROM " + ::cTableName + " WHERE nombre = " + toSQLString( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//

