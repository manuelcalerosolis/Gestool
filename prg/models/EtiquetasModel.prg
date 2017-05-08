
#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS EtiquetasModel FROM SQLBaseEmpresasModel

   DATA     cTableName

   DATA     cDbfTableName

   DATA     hColumns

   DATA     hDbfToCategory

   METHOD   New()

   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) )

   METHOD   loadChildBuffer()

   METHOD   updateAfterDelete()

   METHOD   deleteSelection( aRecno )              INLINE   ( getSQLDatabase():Query( ::getdeleteSentence( aRecno ) ), ::updateAfterDelete( aRecno ), ::buildRowSet() )

   METHOD   insertChildBuffer()                    INLINE   ( getSQLDatabase():Query( ::getInsertSentence() ), ::buildRowSetWithRecno() )

   METHOD   getImportSentence( cPath )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "etiquetas"

   ::cDbfTableName               := ""

   ::hColumns                    := {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"          ,;
                                                         "text"		=> "Identificador"}                             ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 50 ) NOT NULL"                     ,;
   															         "text"		=> "Nombre de la etiqueta"}                     ,;
                                       "empresa"   => {  "create"    => "CHAR ( 4 )"                                 ,;
                                                         "text"      => "Empresa a la que pertenece la etiqueta"}    ,;
                                       "id_padre"  => {  "create"    => "INTEGER"                                    ,;
                                                         "text"      => "Identificador de la etiqueta padre"}        }

   ::Super:New()

   ::cGeneralSelect              := "select id, nombre, empresa, id_padre, nombre_padre"   +;
                                    " from etiquetas left join"                           +;
                                    " (select id as id_del_padre, nombre as nombre_padre from etiquetas)"+;
                                    " on id_padre = id_del_padre"

   ::hDbfToCategory              := {  "Categorias" => { "padre" =>  "Categorias"   ,;
                                                         "hijos" =>  "cNombre"   }}



RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD   updateAfterDelete( aRecno )

   local aId               := ::convertRecnoToId( aRecno )

   local cUpdateOnDelete   := "UPDATE " + ::cTableName +  " SET id_padre = null WHERE "

   aeval( aId, {| v | cUpdateOnDelete += "id_padre = " + toSQLString( v ) + " or " } )

   cUpdateOnDelete        := ChgAtEnd( cUpdateOnDelete, '', 4 )

   getSQLDatabase():Query( cUpdateOnDelete )

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

//---------------------------------------------------------------------------//

METHOD   getImportSentence( cPath )

   local aConstructor := hb_hkeys( ::hDbfToCategory )
   local cDbfTable
   local hContentDbfTable
   local cFatherInsert
   local cFindIdOfFathers
   local nIdOfFathers
   local cChildrenInsert
   local cChildrenValues
   local dbf

   default cPath     := "EMP" + cCodEmp()

   for each cDbfTable in ( aConstructor )

      hContentDbfTable  := ::hDbfToCategory [ cDbfTable ]

      cFatherInsert     := "INSERT INTO " + ::cTableName + " (nombre, empresa, id_padre) VALUES  ( " +;
                            toSQLString( hContentDbfTable[ "padre" ] ) + ", " + toSQLString( cCodEmp() ) + ", null )"

      //getSQLDatabase():Query( cFatherInsert )

      msgalert( cFatherInsert )

      cFindIdOfFathers := "SELECT id FROM " + ::cTableName + " WHERE nombre = " + toSQLString( hContentDbfTable[ "padre" ] )

      nIdOfFathers := ::selectFetchArray( cFindIdOfFathers )[1][1]

      msgalert( nIdOfFathers )

      dbUseArea( .t., cLocalDriver(), cPath + "\" + cDbfTable + ".dbf", cCheckArea( "dbf", @dbf ), .f. )

      if ( dbf )->( neterr() )
      msgalert( "aqui hay un problema")
      Return ( cChildrenInsert )
      end if 

      cChildrenInsert := "INSERT INTO " + ::cTableName +  " ( nombre, empresa, id_padre) VALUES "

      msgalert( cChildrenInsert, "hemos pasado de la apertura del dbf")

      ( dbf )->( dbgotop() )

      while ( dbf )->( !eof() )

         cChildrenValues           += "( " + toSQLString( ( dbf )->( fieldget( fieldpos( hget( hContentDbfTable, "hijos" ) ) ) ) ) + ", " + toSQLString( cCodEmp() ) + ", " + toSQLString( nIdOfFathers ) + "), "

         ( dbf )->( dbskip() )

      end while

      msgalert( "hemos pasado el bucle while")

         cChildrenValues           := chgAtEnd( cChildrenValues, ' )', 2 )

      ( dbf )->( dbclosearea() )

      cChildrenInsert += cChildrenValues

      msgalert( cChildrenInsert , "Asi queda la sentencia para los hijos")

      msgalert( cChildrenInsert )

   next

RETURN ( self )