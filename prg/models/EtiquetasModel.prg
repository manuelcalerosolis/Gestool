
#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS EtiquetasModel FROM SQLBaseModel

   DATA     cTableName

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) )

   METHOD   loadChildBuffer()

   METHOD   deleteSelection()

   METHOD   insertChildBuffer()                    INLINE   ( msgalert( ::getInsertSentence ) ) //( getSQLDatabase():Query( ::getUpdateSentence() ), ::buildRowSetWithRecno() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "etiquetas"

   ::cDbfTableName               := ""

   ::hColumns                    := {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"  ,;
                                                         "text"		=> "Identificador"                      ,;
   															         "dbfField" 	=> "" }                                 ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 50 ) NOT NULL"             ,;
   															         "text"		=> "Nombre de la etiqueta"              ,;
   															         "dbfField" 	=> "" }                                 ,;
                                       "imagen"    => {  "create"    => "VARCHAR ( 50 )"                     ,;
                                                         "text"      => "Imagen que acompaña la etiqueta"    ,;
                                                         "dbfField"  => "" }                                 ,;
                                       "id_padre"  => {  "create"    => "INTEGER"                            ,;
                                                         "text"      => "Identificador de la etiqueta padre" ,;
                                                         "dbfField"  => "" }                                 }

   ::Super:New()

   ::cGeneralSelect              := "select id, nombre, imagen, id_padre, nombre_padre"   +;
                                    " from etiquetas left join"                           +;
                                    " (select id as id_del_padre, nombre as nombre_padre from etiquetas)"+;
                                    " on id_padre = id_del_padre"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD   deleteSelection()

   local cUpdateOnDelete

   cUpdateOnDelete := "UPDATE " + ::cTableName +  " SET id_padre = null WHERE id_padre = " + toSQLString( ::oRowSet:fieldGet( ::cColumnKey ) )

   getSQLDatabase():Query( ::getdeleteSentence() )
   getSQLDatabase():Query( cUpdateOnDelete )
   ::buildRowSet()

RETURN ( self )


//---------------------------------------------------------------------------//

METHOD   loadChildBuffer()

   local aColumnNames := hb_hkeys( ::hColumns )

   if empty( ::oRowSet )
      Return ( .f. )
   end if

   ::hBuffer  := {=>}

   aeval( aColumnNames, {| k | hset( ::hBuffer, k , if ( k == "id_padre", ::oRowSet:fieldget( "id" ), "" ) ) } )

Return ( .t. )