#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasModel FROM SQLBaseModel

   DATA     cTableName           INIT "tipos_ventas"

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

   METHOD   getCodigoFromId( id )
   METHOD   getIdFromCodigo( codigo )

   METHOD   arrayTiposVentas()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cDbfTableName				 	:= "TVta"

   ::hColumns                   	:= {  "id"     => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                      "text"		=> "Identificador"                        ,;
   															      "dbfField" 	=> ""}                                    ,;
                                       "codigo" => {  "create"    => "VARCHAR( 2 )"                         ,;
                                                      "text"      => "Código"                               ,; 
                                                      "dbfField"  => "cCodMov"}                             ,;
                                       "nombre" => {  "create"    => "VARCHAR( 20 ) NOT NULL"               ,;
   															      "text"		=> "Nombre"                               ,;
   															      "dbfField" 	=> "cDesMov"}                             }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getCodigoFromId( id )

   local cCodigo                 := space( 2 )
   local cSentence               := "SELECT codigo FROM " + ::cTableName + " WHERE id = " + toSQLString( id )
   local aSelect                 := ::selectFetchHash( cSentence ) 

   if !empty( aSelect )
      cCodigo                    := padr( hget( atail( aSelect ), "codigo" ), 2 )
   end if 

RETURN ( cCodigo )

//---------------------------------------------------------------------------//

METHOD getIdFromCodigo( codigo )

   local id                      := 0
   local cSentence               := "SELECT id FROM " + ::cTableName + " WHERE codigo = " + toSQLString( codigo )
   local aSelect                 := ::selectFetchHash( cSentence ) 

   if !empty( aSelect )
      id                         := hget( atail( aSelect ), "id" )
   end if 

RETURN ( id )

//---------------------------------------------------------------------------//

METHOD arrayTiposVentas()

   local cSentence               := "SELECT id, codigo FROM " + ::cTableName
   local aResult                 := ::selectFetchHash( cSentence ) 

RETURN ( aResult )

//---------------------------------------------------------------------------//

