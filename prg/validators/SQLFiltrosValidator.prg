#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD uniqueFilter()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre del filtro es un dato requerido",;
                                       "uniquefilter" => "El nombre del filtro ya existe" },;
                        "filtro" => {  "required"     => "La sentencia es un dato requerido" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD uniqueFilter( uValue )

   local id
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()             + space( 1 )
   cSQLSentence      +=    "WHERE nombre = " + toSQLString( uValue )                            + space( 1 )
   cSQLSentence      +=       "AND tabla = " + toSQLString( ::oController:getTableToFilter() )  + space( 1 )

   id                := ::oController:getModelBufferColumnKey()
   if !empty(id)
      cSQLSentence   +=    "AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

RETURN ( getSQLDatabase():getValue( cSQLSentence, 0 ) == 0 )

//---------------------------------------------------------------------------//   

