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

   METHOD translateNameFromId( nId )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                      := "Tipos incidencias"

   ::cDbfTableName				 	:= "TIPINCI"

   ::hColumns                   	:= {  "id"                 => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"          ,;
                                                                  "text"		=> "Identificador"                              ,;
   															                  "dbfField" 	=> "" }                                         ,;
                                       "codigo"             => {  "create"    => "VARCHAR( 3 )"                               ,;
                                                                  "text"      => "Código de identificación en DBF"            ,; 
                                                                  "dbfField"  => "CCODINCI"}                                  ,;  
                                       "nombre_incidencia"  => {  "create"    => "VARCHAR (50) NOT NULL"                      ,;
                                                                  "text"      => "Nombre de la incidencia"                    ,;
                                                                  "dbfField"  => "CNOMINCI"}                                  ,;
                                       "empresa"            => {  "create"    => "CHAR ( 4 )"                                 ,;
                                                                  "text"      => "Empresa a la que pertenece la etiqueta"     ,;
                                                                  "dbfField"  => "" }                                         }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposIncidencias()

   local cSentence               := "SELECT nombre_incidencia FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

RETURN ( aSelect )

//---------------------------------------------------------------------------//

METHOD exist( cValue )

   local cSentence               := "SELECT id FROM " + ::cTableName + " WHERE codigo = " + toSQLString( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//

METHOD translateNameFromId( nId )

   local cSentence   := "SELECT nombre_incidencia from " + ::cTableName + " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND codigo = " + toSQLString( nID )

   local aNombre     := ::selectFetchArray( cSentence )

RETURN ( self )