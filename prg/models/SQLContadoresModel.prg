#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLContadoresModel FROM SQLCompanyModel

   DATA cTableName                     INIT "contadores"

   DATA cConstraints                   INIT "PRIMARY KEY (id), UNIQUE KEY ( documento, serie )"

   METHOD getColumns()

   METHOD isSerie( cDocumento, cSerie )
   METHOD insertSerie( cDocumento, cSerie, nContador )

   METHOD getLastCounter()                          
   METHOD getDocumentCounter()                          
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "usuario_codigo", {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "default"   => {|| Auth():Codigo() } }                   )

   hset( ::hColumns, "documento",      {  "create"    => "VARCHAR ( 250 )"                         ,;
                                          "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "serie",          {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "contador",       {  "create"    => "INT UNSIGNED"                            ,;
                                          "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertSerie( cDocumento, cSerie, nContador )

   local hBuffer        := ::loadBlankBuffer()

   DEFAULT nContador    := 0

   hset( hBuffer, "documento",   cDocumento  )
   hset( hBuffer, "serie",       cSerie      )
   hset( hBuffer, "contador",    nContador   )

RETURN ( ::insertOnDuplicateTransactional( hBuffer ) )   

//---------------------------------------------------------------------------//

METHOD isSerie( cDocumento, cSerie )

   local cSql  := "SELECT id"                                              + " "
   cSql        +=    "FROM " + ::getTableName()                            + " "
   cSql        +=    "WHERE documento = " + quoted( cDocumento )           + " "
   cSql        +=    "AND serie = " + quoted( cSerie )

RETURN ( !empty( ::getDatabase():getValue( cSql ) ) )

//---------------------------------------------------------------------------//

METHOD getLastCounter( cDocumento )

   local cSql  := "SELECT serie, contador"                                 + " "
   cSql        +=    "FROM " + ::getTableName()                            + " "
   cSql        +=    "WHERE documento = " + quoted( cDocumento )           + " "
   cSql        +=    "AND usuario_codigo = " + quoted( Auth():Codigo() )   + " "
   cSql        +=    "ORDER BY updated_at DESC"                            + " " 
   cSql        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSql ) ) 

//---------------------------------------------------------------------------//
   
METHOD getDocumentCounter( cDocumento )                          

   local cDocument   := ""
   local hDocument   := ::getLastCounter( cDocumento )

   if empty( hDocument )
      RETURN ( padl( "1", 6, "0" ) )
   end if

   if !empty( hget( hDocument, "serie" ) )
      cDocument      := hget( hDocument, "serie" ) + "/"
   end if 

   cDocument         += alltrim( padl( hget( hDocument, "contador" ) + 1, 6, "0" ) )

RETURN ( cDocument )

//---------------------------------------------------------------------------//
