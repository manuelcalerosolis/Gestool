
#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS EtiquetasModel FROM SQLBaseEmpresasModel

   DATA     cTableName                             INIT "etiquetas"

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

   METHOD   translateIdsToNames( aIds )

   METHOD   translateNamesToIds( aNames )


END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cDbfTableName               := ""

   ::hColumns                    := {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"          ,;
                                                         "text"		=> "Identificador"}                             ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 50 ) NOT NULL"                     ,;
   															         "text"		=> "Nombre de la etiqueta"}                     ,;
                                       "empresa"   => {  "create"    => "CHAR ( 4 )"                                 ,;
                                                         "text"      => "Empresa a la que pertenece la etiqueta"}    ,;
                                       "id_padre"  => {  "create"    => "INTEGER"                                    ,;
                                                         "text"      => "Identificador de la etiqueta padre" }       ,;
                                       "codigo"    => {  "create"    => "CHAR ( 10 )"                                ,;
                                                         "text"      => "Identificador de la etiqueta padre"         }}

   ::Super:New()

   ::cGeneralSelect              := "SELECT id, nombre, empresa, id_padre, nombre_padre"                                +;
                                    " FROM " + ::cTableName + " LEFT JOIN "                                             +;
                                    " ( SELECT id AS id_del_padre, nombre AS nombre_padre FROM " + ::cTableName + " )"  +;
                                    " ON id_padre = id_del_padre"

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

METHOD makeParent( cName )

   local cParentInsert

   cParentInsert        := "INSERT INTO " + ::cTableName + " ( "     + ;
                              "nombre, empresa, id_padre ) "         + ;
                           "VALUES  ( "                              + ;
                              toSQLString( cName ) + ", " + toSQLString( cCodEmp() ) + ", null )"

   getSQLDatabase():Query( cParentInsert )

RETURN ( getSQLDatabase():LastInsertId() )

//---------------------------------------------------------------------------//

METHOD getSentenceFromOldCategories( idParent )

   local dbf
   local cSentence   := "INSERT INTO " + ::cTableName +  " ( nombre, empresa, id_padre, codigo) VALUES "
   local cValues     := ""

   dbUseArea( .t., cDriver(), cPatEmp() + "Categorias.Dbf", cCheckArea( "Categorias", @dbf ) )

   if ( dbf )->( neterr() )
      RETURN ( nil )
   end if 

   ( dbf )->( dbgotop() )

   while ( dbf )->( !eof() )

      cValues     += "( " + toSQLString( ( dbf )->cNombre ) + ", " + toSQLString( cCodEmp() ) + ", " + toSQLString( idParent ) + ", " + toSQLString( ( dbf )->cCodigo ) + "), "

      ( dbf )->( dbskip() )

   end while
   
   ( dbf )->( dbclosearea() )

   if empty(cValues)
      RETURN ( nil )
   end if 
      
   cSentence      += chgAtEnd( cValues, "", 2 )

   msgalert( cSentence )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD makeImportCategorias()

   local cImportSentence
   local nIdOfCategoria
   local cPath := cPatEmp()

   if ( file( cFullPathEmpresa() + "Categorias.old" ) )
      Return ( self )
   end if

   if !( file( cFullPathEmpresa() + "Categorias.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Categorias.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   nIdOfCategoria   := ::makeParent( "Categorias" )

   cImportSentence   := ::getSentenceFromOldCategories( nIdOfCategoria )

   if !empty( cImportSentence )

      getSQLDatabase():Exec( cImportSentence )
      
   end if 

   frename( cFullPathEmpresa() + "Categorias.dbf", cFullPathEmpresa() + "Categorias.old" )
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD makeImportDbfSQL()

   ::makeImportCategorias()
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD translateIdsToNames( aIds )

   local cTranslate := "SELECT nombre FROM " + ::cTableName + " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND ( "

   if empty( aIds )
      RETURN ( nil )
   end if

   aeval( aIds, { | nID | cTranslate += " id = " + toSQLString ( nID ) + " OR" } )

   cTranslate := chgAtEnd( cTranslate, " )", 3 )

RETURN ( ::selectFetchArray( cTranslate ) )

//---------------------------------------------------------------------------//

METHOD translateNamesToIds( aNames )

   local cTranslate := "SELECT id FROM " + ::cTableName + " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND ( "

   if empty( aNames )
      RETURN ( nil )
   end if

   aeval( aNames, { | cName | cTranslate += " nombre = " + toSQLString ( cName ) + " OR" } )

   cTranslate := chgAtEnd( cTranslate, " )", 3 )

RETURN ( ::selectFetchArray( cTranslate ) )

//temporada