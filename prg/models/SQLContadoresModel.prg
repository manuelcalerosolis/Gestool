#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLContadoresModel FROM SQLCompanyModel

   DATA cTableName                     INIT "contadores"

   DATA cConstraints                   INIT "PRIMARY KEY (id), UNIQUE KEY ( documento, serie )"

   METHOD getColumns()

   METHOD isSerie( cDocument, cSerial )
   METHOD insertSerie( cDocument, cSerial, nCounter )
   METHOD getLastSerie( cDocument )
   METHOD getDocumentSerie( cDocument )                          

   METHOD getLastCounter()                          
   METHOD getDocumentCounter()    

   METHOD getCounter( cDocument, cSerial )

   METHOD incrementalDocument( cDocument, cSerial )

   METHOD getPosibleNext( cDocument, cSerial ) ;
                                       INLINE ( ::getCounter( cDocument, cSerial ) + 1 )

   METHOD getNext( cDocument, cSerial )
   
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

METHOD insertSerie( cDocument, cSerial, nCounter )

   local hBuffer        := ::loadBlankBuffer()

   DEFAULT nCounter     := 0

   hset( hBuffer, "documento",   cDocument   )
   hset( hBuffer, "serie",       cSerial     )
   hset( hBuffer, "contador",    nCounter    )

RETURN ( ::insertOnDuplicateTransactional( hBuffer ) )   

//---------------------------------------------------------------------------//

METHOD isSerie( cDocument, cSerial )

   local cSql  := "SELECT id"                                              + " "
   cSql        +=    "FROM " + ::getTableName()                            + " "
   cSql        +=    "WHERE documento = " + quoted( cDocument )           + " "
   cSql        +=    "AND serie = " + quoted( cSerial )

RETURN ( !empty( ::getDatabase():getValue( cSql ) ) )

//---------------------------------------------------------------------------//

METHOD getLastSerie( cDocument )

   local cSql  := "SELECT serie"                                           + " "
   cSql        +=    "FROM " + ::getTableName()                            + " "
   cSql        +=    "WHERE documento = " + quoted( cDocument )           + " "
   cSql        +=    "AND usuario_codigo = " + quoted( Auth():Codigo() )   + " "
   cSql        +=    "ORDER BY updated_at DESC"                            + " " 
   cSql        +=    "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSql ) ) 

//---------------------------------------------------------------------------//
   
METHOD getDocumentSerie( cDocument )                          

   local cSerial     := ::getLastSerie( cDocument )

   if empty( cSerial )
      RETURN ( padr( "A", 20 ) )
   end if

RETURN ( padr( cSerial, 20 ) )

//---------------------------------------------------------------------------//

METHOD getLastCounter( cDocument )

   local cSql  := "SELECT contador"                                        + " "
   cSql        +=    "FROM " + ::getTableName()                            + " "
   cSql        +=    "WHERE documento = " + quoted( cDocument )           + " "
   cSql        +=    "AND usuario_codigo = " + quoted( Auth():Codigo() )   + " "
   cSql        +=    "ORDER BY updated_at DESC"                            + " " 
   cSql        +=    "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSql ) ) 

//---------------------------------------------------------------------------//
   
METHOD getDocumentCounter( cDocument )                          

   local nCounter    := ::getLastCounter( cDocument )

   if empty( nCounter )
      RETURN ( 1 )
   end if

RETURN ( nCounter + 1 )

//---------------------------------------------------------------------------//

METHOD getCounter( cDocument, cSerial )

   local cSql

   TEXT INTO cSql

   SELECT contador

      FROM %1$s

      WHERE documento = %2$s
         AND serie = %3$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cDocument ), quoted( cSerial ) )

RETURN ( ::getDatabase():getValue( cSql, 1 ) ) 

//---------------------------------------------------------------------------//

METHOD incrementalDocument( cDocument, cSerial )

   local cSql

   TEXT INTO cSql

   UPDATE %1$s
      
      SET contador = contador + 1

      WHERE documento = %2$s
         AND serie = %3$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cDocument ), quoted( cSerial ) )

RETURN ( ::getDatabase():Exec( cSql ) ) 

//---------------------------------------------------------------------------//

METHOD getNext( cDocument, cSerial )

   ::incrementalDocument( cDocument, cSerial )

RETURN ( ::getCounter( cDocument, cSerial ) )

//---------------------------------------------------------------------------//
