
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

   METHOD   makeParent()

   METHOD   makeImportCategorias()

   METHOD   makeImportDbfSQL()

   METHOD   getSentenceFromOldCategories( idParent )

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

<<<<<<< HEAD
METHOD getImportSentence( cPath )
=======
METHOD makeParent( cName )

   local cParentInsert

   msgalert( "estoy a punto de hacer el padre")

   cParentInsert        := "INSERT INTO " + ::cTableName + " ( "     + ;
                              "nombre, empresa, id_padre ) "         + ;
                           "VALUES  ( "                              + ;
                              toSQLString( cName ) + ", " + toSQLString( cCodEmp() ) + ", null )"

                              msgalert( cParentInsert , "esta es la sentencia sql")

   getSQLDatabase():Query( cParentInsert )

RETURN ( getSQLDatabase():LastInsertId() )

//---------------------------------------------------------------------------//

METHOD getSentenceFromOldCategories( idParent )
>>>>>>> dee95e552b3a344e93713a3807f10131c6eb0472

   local dbf
   local cSentence   := "INSERT INTO " + ::cTableName +  " ( nombre, empresa, id_padre) VALUES "
   local cValues     := ""

   dbUseArea( .t., cDriver(), cPatEmp() + "Categorias.Dbf", cCheckArea( "Categorias", @dbf ) )

   ( dbf )->( dbgotop() )

   while ( dbf )->( !eof() )

      cValues     += "( " + toSQLString( ( dbf )->cNombre ) + ", " + toSQLString( cCodEmp() ) + ", " + toSQLString( idParent ) + "), "

      ( dbf )->( dbskip() )

   end while
   
   ( dbf )->( dbclosearea() )

   if empty(cValues)
      RETURN ( nil )
   end if 
      
   cSentence      += chgAtEnd( cValues, "", 2 )

RETURN ( cSentence )

<<<<<<< HEAD
      if ( dbf )->( neterr() )
         Return ( Self )
      end if 
=======
//---------------------------------------------------------------------------//
>>>>>>> dee95e552b3a344e93713a3807f10131c6eb0472

METHOD makeImportCategorias()

   local cImportSentence
   local nIdOfCategoria
   local cPath := cPatEmp()

   msgalert( "primeros pasos")

   if ( file( cFullPathEmpresa() + "Categorias.old" ) )
      Return ( self )
   end if

   if !( file( cFullPathEmpresa() + "Categorias.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Categorias.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   msgalert("pasamos del if")

   nIdOfCategoria   := ::makeParent( "Categorias" )

   msgalert( nIdOfCategoria )

   cImportSentence   := ::getSentenceFromOldCategories( nIdOfCategoria )

   msgalert("tenemos las sentencias SQL")

   if !empty( cImportSentence )

      getSQLDatabase():Exec( cImportSentence )
      
   end if 

   msgalert("ya las hemos ejecutado")

   frename( cFullPathEmpresa() + "Categorias.dbf", cFullPathEmpresa() + "Categorias.old" )

   msgalert("ya le hemos cambiado el nombre al archivo")
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD makeImportDbfSQL()

   ::makeImportCategorias()
   
Return ( self )

//---------------------------------------------------------------------------//



//temporada