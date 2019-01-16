#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLContadoresModel FROM SQLCompanyModel

   DATA cTableName                     INIT "contadores"

   DATA cConstraints                   INIT "PRIMARY KEY (id), UNIQUE KEY ( documento, serie )"

   METHOD getColumns()

   METHOD isSerie( cDocument, cSerial )
   METHOD assertSerie( cDocument )
   METHOD insertSerie( cDocument, cSerial, nCounter )

   METHOD getLastSerie( cDocument )
   METHOD getLastCounter( cDocument )                          

   METHOD incrementCounter( cDocument, cSerial )

   METHOD getCounterAndIncrement( cDocument, cSerial )
   
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

   DEFAULT cSerial      := 'A'
   DEFAULT nCounter     := 1

   hset( hBuffer, "documento", cDocument )
   hset( hBuffer, "serie", cSerial )
   hset( hBuffer, "contador", nCounter )

RETURN ( ::insertIgnoreTransactional( hBuffer ) )   

//---------------------------------------------------------------------------//

METHOD isSerie( cDocument, cSerial )

RETURN ( !empty( ::getFieldWhere( 'id', { 'documento' => cDocument, 'serie' => cSerial } ) ) ) 

//---------------------------------------------------------------------------//

METHOD assertSerie( cDocument )

   if empty( ::getFieldWhere( 'serie', { 'documento' => cDocument } ) )
      RETURN ( ::insertSerie( cDocument ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getLastSerie( cDocument )

   local cSerie

   ::assertSerie( cDocument )

   cSerie      := ::getFieldWhere( 'serie',;
                                    {  'documento' => cDocument, 'usuario_codigo' => Auth():Codigo() },;
                                    {  'updated_at' => 'DESC' } )

   if empty( cSerie )   
      cSerie   := ::getFieldWhere( 'serie',;
                                    {  'documento' => cDocument },;
                                    {  'updated_at' => 'DESC' } )
   end if 

RETURN ( cSerie )

//---------------------------------------------------------------------------//

METHOD getLastCounter( cDocument, cSerial )

   ::assertSerie( cDocument )

RETURN ( ::getFieldWhere( 'contador', { 'documento' => cDocument, 'serie' => cSerial }, { 'updated_at' => 'DESC' }, 1 ) ) 

//---------------------------------------------------------------------------//
   
METHOD incrementCounter( cDocument, cSerial )

RETURN ( ::updateFieldsWhere( { 'contador' => 'contador + 1', 'updated_at' => 'NOW()' }, { 'documento' => cDocument, 'serie' => cSerial } ) )

//---------------------------------------------------------------------------//

METHOD getCounterAndIncrement( cDocument, cSerial )

   local nCounter    := ::getLastCounter( cDocument, cSerial )

   ::incrementCounter( cDocument, cSerial )

RETURN ( nCounter )

//---------------------------------------------------------------------------//
