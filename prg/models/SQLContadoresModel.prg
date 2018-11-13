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

RETURN ( !empty( ::getFieldWhere( 'id', { 'documento' => ( cDocument ), 'serie' => ( cSerial ) } ) ) ) 

//---------------------------------------------------------------------------//

METHOD getLastSerie( cDocument )

RETURN ( ::getFieldWhere( 'serie',;
            {  'documento' => cDocument, 'usuario_codigo' => Auth():Codigo() },;
            {  'updated_at' => 'DESC' } ) ) 

//---------------------------------------------------------------------------//

METHOD getLastCounter( cDocument )

RETURN ( ::getFieldWhere( 'contador',;
            {  'documento' => cDocument, 'usuario_codigo' => Auth():Codigo() },;
            {  'updated_at' => 'DESC' } ) ) 

//---------------------------------------------------------------------------//

METHOD getDocumentSerie( cDocument )                          

   local cSerial     := ::getLastSerie( cDocument )

   if empty( cSerial )
      RETURN ( padr( "A", 20 ) )
   end if

RETURN ( padr( cSerial, 20 ) )

//---------------------------------------------------------------------------//
   
METHOD getDocumentCounter( cDocument )                          

   local nCounter    := ::getLastCounter( cDocument )

   if empty( nCounter )
      RETURN ( 1 )
   end if

RETURN ( nCounter + 1 )

//---------------------------------------------------------------------------//

METHOD getCounter( cDocument, cSerial )

RETURN ( ::getFieldWhere(  'contador',;
                           { 'documento' => cDocument, 'serie' => cSerial }, , 1 ) )

//---------------------------------------------------------------------------//

METHOD incrementalDocument( cDocument, cSerial )

RETURN ( ::updateFieldsWhere( { 'contador' => 'contador + 1', 'updated_at' => 'NOW()' },;
                              { 'documento' => cDocument, 'serie' => cSerial } ) )

//---------------------------------------------------------------------------//

METHOD getNext( cDocument, cSerial )

   ::incrementalDocument( cDocument, cSerial )

RETURN ( ::getCounter( cDocument, cSerial ) )

//---------------------------------------------------------------------------//
