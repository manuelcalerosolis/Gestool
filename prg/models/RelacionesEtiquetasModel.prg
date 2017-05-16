#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS RelacionesEtiquetasModel FROM SQLBaseEmpresasModel

   DATA cTableName               INIT "relaciones_etiquetas"

   DATA hColumns

   METHOD New()

   METHOD TrasnlateCodigoToId()

   METHOD getLineasProducccion()

   METHOD getIdEtiquetaFromCategoria( cCodigoCategoria, aSelect )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                   	:= {  "id"              	=> {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"       						,;
                                                                  "text"		=> "Identificador"}                           						,;                        					
                                       "id_padre"           => {  "create"    => "INTEGER"                                                   ,;
                                                                  "text"      => "Identificador padre"}                                      ,;                                     
                                       "tabla_padre"        => {  "create"    => "VARCHAR (50) NOT NULL"                                     ,;
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

METHOD TrasnlateCodigoToId()

   local aSelect     
   local hSelect
   local cSentence              

   aSelect           := EtiquetasModel():arrayCodigoAndId()

   if empty( aSelect )
      RETURN ( Self )
   end if 

   for each hSelect in aSelect

      cSentence      := "UPDATE EMP" + ( cCodEmp() + "ProLin" )                     + ;
                              " SET cEtiqueta = '" + toSQLString( hSelect["id"] )   + ;
                              "', ccodcat = null "                                  + ;
                           "WHERE ccodcat = " + toSQLString( hSelect["codigo"] )

      BaseModel():ExecuteSqlStatement( cSentence )

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getLineasProducccion()

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
         cValueSentence += (dbfAlias)->cSerOrd + str( (dbfAlias)->nNumOrd, 9 ) + (dbfAlias)->cSufOrd + str( (dbfAlias)->nNumLin, 4 )   + ", "
         cValueSentence += ::getIdEtiquetaFromCategoria( cCodigoCategoria, aSelect )

         ( dbfAlias )->( dbskip() )
      end while


   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getIdEtiquetaFromCategoria( cCodigoCategoria, aSelect )

   local nPosition

   nPosition   := ascan( aSelect, {|h| hget( h, "codigo" ) == cCodigoCategoria } )
   if nPosition != 0
      RETURN( hget( aSelect[nPosition], "id" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//


