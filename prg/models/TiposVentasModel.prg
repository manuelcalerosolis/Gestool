#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasModel FROM SQLBaseModel

   DATA cTableName               INIT "tipos_ventas"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD arrayTiposVentas()

   METHOD exist( cValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                      := "Tipos ventas"

   ::cDbfTableName				 	:= "TVTA"

   ::hColumns                   	:= {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                         "text"		=> "Identificador"                        ,;
   															         "dbfField" 	=> ""}                                    ,;
                                       "codigo"    => {  "create"    => "VARCHAR( 2 )"                         ,;
                                                         "text"      => "Código de identificación en DBF"      ,; 
                                                         "dbfField"  => "CCODMOV"}                             ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 20 ) NOT NULL"               ,;
   															         "text"		=> "Descripción del movimiento"           ,;
   															         "dbfField" 	=> "CDESMOV"}                             }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposVentas()

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aResult                 := ::selectFetchArray( cSentence ) 

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD exist( cValue )

   local cSentence               := "SELECT codigo FROM " + ::cTableName + " WHERE codigo = " + toSQLString( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//


