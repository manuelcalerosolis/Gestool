#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposIncidenciasModel FROM SQLBaseEmpresasModel

   DATA cTableName                        INIT "tipos_incidencias"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD arrayTiposIncidencias()

   METHOD exist( cValue )

   METHOD getNameFromCodigo( uValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                      := "Tipos incidencias"

   ::cDbfTableName				 	:= "TipInci"

   ::hColumns                   	:= {  "id"                 => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"          ,;
                                                                  "text"		=> "Identificador"                              ,;
   															                  "dbfField" 	=> "" }                                         ,;
                                       "codigo"             => {  "create"    => "VARCHAR( 3 )"                               ,;
                                                                  "text"      => "Código de identificación en DBF"            ,; 
                                                                  "dbfField"  => "cCodInci"}                                  ,;  
                                       "nombre"             => {  "create"    => "VARCHAR (50) NOT NULL"                      ,;
                                                                  "text"      => "Nombre de la incidencia"                    ,;
                                                                  "dbfField"  => "cNomInci"}                                  ,;
                                       "empresa"            => {  "create"    => "CHAR ( 4 )"                                 ,;
                                                                  "text"      => "Empresa a la que pertenece la etiqueta"     ,;
                                                                  "dbfField"  => "" }                                         }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposIncidencias()

   local cSentence   := "SELECT nombre FROM " + ::cTableName
   local aSelect     := ::selectFetchArray( cSentence ) 

RETURN ( aSelect )

//---------------------------------------------------------------------------//

METHOD exist( cValue )

   local cSentence   := "SELECT id FROM " + ::cTableName + " WHERE codigo = " + toSQLString( cValue )
   local aSelect     := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//

METHOD getNameFromCodigo( uValue )

   local cName       := ""
   local cSentence   := "SELECT nombre FROM " + ::cTableName + " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND codigo = " + toSQLString( uValue )
   local aSelect     := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      cName          := hget( atail( aSelect ), "nombre" )
   end if 

RETURN ( cName )

//---------------------------------------------------------------------------//

