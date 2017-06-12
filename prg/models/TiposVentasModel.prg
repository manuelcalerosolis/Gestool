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
   															      "header"    => "Id"                                   ,;
                                                      "visible"   => .f.                                    ,;
                                                      "width"     => 40}                                    ,;
                                       "codigo" => {  "create"    => "VARCHAR( 2 )"                         ,;
                                                      "text"      => "Código"                               ,; 
                                                      "header"    => "Código"                               ,;
                                                      "visible"   => .t.                                    ,;
                                                      "width"     => 80                                     ,;
                                                      "field"     => "cCodMov"                              ,;
                                                      "type"      => "C"                                    ,;
                                                      "len"       => 2}                                     ,;
                                       "nombre" => {  "create"    => "VARCHAR( 20 ) NOT NULL"               ,;
   															      "text"		=> "Nombre"                               ,;
                                                      "header"    => "Nombre"                               ,;
                                                      "visible"   => .t.                                    ,;
                                                      "width"     => 600                                    ,;
   															      "field" 	   => "cDesMov"                              ,;
                                                      "type"      => "C"                                    ,;
                                                      "len"       => 20}                                    }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getCodigoFromId( id )

   local cCodigo                 := space( 2 )
   local aSelect                 
   local cSentence               

   if empty( id )
      RETURN ( cCodigo )
   end if 

   cSentence                     := "SELECT codigo FROM " + ::cTableName + " WHERE id = " + toSQLString( id )

   aSelect                       := ::selectFetchHash( cSentence ) 

   if !empty( aSelect )
      cCodigo                    := padr( hget( atail( aSelect ), "codigo" ), 2 )
   end if 

RETURN ( cCodigo )

//---------------------------------------------------------------------------//

METHOD getIdFromCodigo( codigo )

   local id                      := 0
   local aSelect     
   local cSentence   

   if empty( codigo )
      RETURN ( id )
   end if 

   cSentence                     := "SELECT id FROM " + ::cTableName + " WHERE codigo = " + toSQLString( codigo )

   aSelect                       := ::selectFetchHash( cSentence ) 

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

