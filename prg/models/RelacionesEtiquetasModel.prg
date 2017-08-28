#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS RelacionesEtiquetasModel FROM SQLBaseModel

   DATA cTableName               INIT "relaciones_etiquetas"

   DATA hColumns

   METHOD New()

   METHOD TranslateCodigoToId()

   METHOD getLineasProducccion()

   METHOD getIdEtiquetaFromCategoria( cCodigoCategoria, aSelect )

   METHOD getRelationsOfEtiquetas( cTableName, nCodLine )

   METHOD setRelationsOfEtiquetas( cTableName, nCodLine, etiquetas )       INLINE ( getSQLDatabase():Query( ::sentenceForInsertLine( cTableName, nCodLine, etiquetas ) ) )

   METHOD sentenceForInsertLine( cTableName, nCodLine, etiquetas )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                   	:= {  "id"              	=> {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"       						,;
                                                                  "text"		=> "Identificador"}                           						,;                        					
                                       "id_padre"           => {  "create"    => "INTEGER"                                                   ,;
                                                                  "text"      => "Identificador padre"}                                      ,;                                     
                                       "tabla_padre"        => {  "create"    => "VARCHAR (50)"                                              ,;
                                                                  "text"      => "Nombre de la tabla padre"}                                 ,;
                                       "id_empresa"         => {  "create"    => "CHAR ( 4 )"                                 					,;
                                                                  "text"      => "Empresa a la que pertenece el documento y etiquetas"}     	,;
                                       "tabla_documento"		=> {  "create"    => "VARCHAR (50) NOT NULL"                      					,;
                                                                  "text"      => "Nombre de la tabla donde está el id_documento"}            ,;
                                       "id_documento"			=>	{	"create"		=>	"VARCHAR( 18 ) NOT NULL"												,;
                                    										"text"		=>	"Identificador de un documento"}										,;
                                    	"etiquetas"				=> {	"create"		=>	"VARCHAR ( 250 )"															,;
                                    										"text"		=>	"Conjunto de etiquetas"}												}

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getIdEtiquetaFromCategoria( cCodigoCategoria, aSelect )

   local nPosition

   nPosition   := ascan( aSelect, {|h| hget( h, "codigo" ) == alltrim( cCodigoCategoria ) } )
   if nPosition != 0
      RETURN( hget( aSelect[nPosition], "id" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getLineasProducccion( cCodigoCategoria )

   local cSentence
   local cInsertSentence
   local cValueSentence := ""
   local dbfAlias       := "PROLIN"
   local dbfTableName   := "EMP" + cCodEmp() + "PROLIN"
   local aSelect        := EtiquetasModel():arrayCodigoAndId()

   cSentence            := "SELECT cSerOrd, nNumOrd, cSufOrd, nNumLin, cCodCat "       + ;
                              "FROM " + dbfTableName + " "                             + ;
                              "WHERE cCodCat IS NOT NULL"

   if BaseModel():ExecuteSqlStatement( cSentence, @dbfAlias )

      cInsertSentence   := "INSERT INTO " + ::cTableName + "( id_empresa, tabla_documento, id_documento, etiquetas ) VALUES "
      
      ( dbfAlias )->( browse() )
      
      ( dbfAlias )->( dbgotop() )
      while !( dbfAlias )->( eof() )

         cValueSentence += "( " + toSQLString( cCodEmp() )                                                                             + ", "  
         cValueSentence += toSQLString( dbfTableName )                                                                                 + ", "
         cValueSentence += "'" + (dbfAlias)->cSerOrd + str( (dbfAlias)->nNumOrd, 9 ) + (dbfAlias)->cSufOrd + str( (dbfAlias)->nNumLin, 4 )   + "', "
         cValueSentence += toSQLString( ::getIdEtiquetaFromCategoria( (dbfAlias)->cCodCat, aSelect ) )                                 + " ), "

         ( dbfAlias )->( dbskip() )
      end while

   end if 

   if empty( cValueSentence )
      RETURN ( nil )
   end if
   
   cInsertSentence += chgAtEnd( cValueSentence, " )", 4 )

RETURN ( cInsertSentence )

//---------------------------------------------------------------------------//

METHOD TranslateCodigoToId()

   local cSentenceSQLite := ::getLineasProducccion()

   local cSentenceDBF := "UPDATE EMP" + cCodEmp() + "PROLIN set cCodCat = null"

   getSQLDatabase():Query( cSentenceSQLite )

   BaseModel():ExecuteSqlStatement( cSentenceDBF )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD sentenceForInsertLine( cTableName, nCodLine, etiquetas )

   local cInsertSentence

   local cInternalSelect   := "( SELECT id FROM " + ::cTableName                       + ;
                              " WHERE id_empresa = " + toSQLString( cCodEmp() )        + ;
                              " AND tabla_documento = " + toSQLString( cTableName )    + ;
                              " AND id_documento = " + toSQLString( nCodLine ) + " ) "

   local cDeleteLine       := "DELETE FROM " + ::cTableName                            + ;
                              " WHERE id_empresa = " + toSQLString( cCodEmp() )        + ;
                              " AND tabla_documento = " + toSQLString( cTableName )    + ;
                              " AND id_documento = " + toSQLString( nCodLine )

   if empty( etiquetas )
       RETURN ( cDeleteLine )
   endif

   cInsertSentence         := "REPLACE INTO " + ::cTableName                           + ;
                                 " ( id, "                                             + ;
                                 "id_empresa, "                                        + ;
                                 "tabla_documento, "                                   + ;
                                 "id_documento, "                                      + ;
                                 "etiquetas ) "                                        + ;
                              "VALUES ( "                                              + ;
                                 cInternalSelect + ", "                                + ;
                                 toSQLString( cCodEmp() ) + ", "                       + ;
                                 toSQLString( cTableName ) + ", "                      + ;
                                 toSQLString( nCodLine ) + ", "                        + ;
                                 toSQLString( hb_serialize( etiquetas ) ) + " ) "

RETURN ( cInsertSentence )

//---------------------------------------------------------------------------//

METHOD getRelationsOfEtiquetas( cTableName, nCodLine )

   local aResult 
   local cSentence
   local aEtiquetas

   cSentence         := "SELECT etiquetas FROM " + ::cTableName                     + ;
                           " WHERE id_empresa = " + toSQLString( cCodEmp() )        + ;
                           " AND tabla_documento = " + toSQLString( cTableName )    + ;
                           " AND id_documento = " + toSQLString( nCodLine )
   aResult           := ::selectFetchArray( cSentence )

   if empty( aResult )
      RETURN ( nil )
   endif

   aEtiquetas        := hb_deserialize( atail( aResult ) )

RETURN ( aEtiquetas )

//---------------------------------------------------------------------------//
